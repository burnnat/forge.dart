library forge.gen.md;

import 'dart:js' as js;

import 'package:js_wrapping_generator/dart_generator.dart';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

import 'util.dart';

@wrapper
abstract class DigestAlgorithm extends jsw.TypedJsObject {
  Digest create() => Digest.$wrap($unsafe.callMethod('create'));
}

@wrapper
abstract class Digest extends jsw.TypedJsObject {
  String get algorithm;

  Digest start() => Digest.$wrap($unsafe.callMethod('start'));

  Digest update(String message, { String encoding: 'raw' })
    => Digest.$wrap($unsafe.callMethod('update', [message, encoding]));

  ByteBuffer digest()
    => ByteBuffer.$wrap($unsafe.callMethod('digest'));

  static Digest $wrap(js.JsObject obj) => null;
}
