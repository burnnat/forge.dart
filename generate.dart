import 'dart:io';

import 'package:js_wrapping_generator/dart_generator.dart';
import 'package:path/path.dart' as path;

void main(List<String> args) {
  bool clean = true;

  Directory template = new Directory('template');
  Directory target = new Directory('lib/src/gen');

  if (clean && target.existsSync()) {
    print('Cleaning output directory...');
    target.deleteSync(recursive: true);
  }

  Generator _generator = new CustomGenerator('packages');

  template
    .listSync()
    .where((fse) => fse is File)
    .forEach((file) {
      print('Wrapping file: ' + file.path);
      _generator.transformFile(file, file, target);
    });
}

class CustomGenerator extends Generator {
  CustomGenerator(String packagesDir) : super(packagesDir);

  void transformFile(File libraryFile, File from, Directory to) {
    super.transformFile(libraryFile, from, to);

    File output = new File(path.join(to.path, path.basename(from.path)));
    String code = output.readAsStringSync();

    code = code.replaceAll(
      new RegExp("import 'package:js_wrapping_generator/dart_generator.dart';\n"),
      ''
    );

    output.writeAsStringSync(code);
  }
}