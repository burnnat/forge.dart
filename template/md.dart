library forge.gen.md;

import 'package:js_wrapping_generator/dart_generator.dart';

import 'util.dart';

@wrapper
abstract class DigestAlgorithm {
  Digest create();
}

@wrapper
abstract class Digest {
  String get algorithm;

  Digest start();
  Digest update(String message, { String encoding: 'raw' });
  ByteBuffer digest();
}
