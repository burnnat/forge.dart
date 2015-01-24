import 'dart:async';
import 'dart:io';

import 'package:analyzer/src/generated/sdk_io.dart';
import 'package:js_wrapping_generator/dart_generator.dart';
import 'package:path/path.dart' as path;

void main(List<String> args) {
  if (DirectoryBasedDartSdk.defaultSdkDirectory == '.') {
    print('WARNING: Default SDK directory not detected. You may need to set the DART_SDK environment variable.');
  }

  Stopwatch stopwatch = new Stopwatch()..start();
  bool clean = true;

  Directory base = new File.fromUri(Platform.script).parent.parent;
  Directory template = new Directory('${base.path}/template');
  Directory target = new Directory('${base.path}/lib/src/gen');

  if (clean && target.existsSync()) {
    print('Cleaning output directory...');
    target.deleteSync(recursive: true);
  }

  Generator _generator = new CustomGenerator('${base.path}/packages');

  template
    .list()
    .where((fse) => fse is File)
    .map((file) {
      print('Parsing file: ${file.path}');
      return new Future.microtask(() {
        _generator.transformFile(file, file, target);
      });
    })
    .toList()
    .then((List<Future> futures) => Future.wait(futures))
    .then((_) {
      print('File generation complete. Elapsed time: ${stopwatch.elapsed}');
    });
}

class CustomGenerator extends Generator {
  CustomGenerator(String packagesDir) : super(packagesDir);

  void transformFile(File libraryFile, File from, Directory to) {
    super.transformFile(libraryFile, from, to);

    File output = new File(path.join(to.path, path.basename(from.path)));
    String code = output.readAsStringSync();

    code = code.replaceFirst(
      new RegExp("import 'package:js_wrapping_generator/dart_generator.dart';\n"),
      ''
    );

    if (Platform.isWindows) {
      code = code.replaceAll(
          new RegExp('\n'),
          '\r\n'
      );
    }

    output.writeAsStringSync(code);
    print('Generated file: ${output.path}');
  }
}
