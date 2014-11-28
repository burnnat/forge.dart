import 'dart:io';

import 'package:js_wrapping_generator/dart_generator.dart';

void main(List<String> args) {
  bool clean = true;

  Directory template = new Directory('template');
  Directory target = new Directory('lib/src/gen');

  if (clean && target.existsSync()) {
    print('Cleaning output directory...');
    target.deleteSync(recursive: true);
  }

  Generator _generator = new Generator('packages');

  template
    .listSync()
    .where((fse) => fse is File)
    .forEach((file) {
      print('Wrapping file: ' + file.path);
      _generator.transformFile(file, file, target);
    });
}
