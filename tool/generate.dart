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

  Generator _generator = new Generator('${base.path}/packages');

  template
    .list()
    .where((fse) => fse is File)
    .map((file) {
      print('Parsing file: ${file.path}');
      return new Future.microtask(() {
        _generator.transformFile(file, file, target);
        print('Generated file: ${path.join(target.path, path.basename(file.path))}');
      });
    })
    .toList()
    .then((List<Future> futures) => Future.wait(futures))
    .then((_) {
      print('File generation complete. Elapsed time: ${stopwatch.elapsed}');
    });
}
