library forge.gen.md;

import 'util.dart';
import 'dart:js' as js;
import 'package:js_wrapping/js_wrapping.dart' as jsw;

class DigestAlgorithm extends jsw.TypedJsObject {
  static DigestAlgorithm $wrap(js.JsObject jsObject) => jsObject == null ? null
      : new DigestAlgorithm.fromJsObject(jsObject);
  DigestAlgorithm.fromJsObject(js.JsObject jsObject) : super.fromJsObject(
      jsObject);
  Digest create() => Digest.$wrap($unsafe.callMethod('create'));
}

class Digest extends jsw.TypedJsObject {
  static Digest $wrap(js.JsObject jsObject) => jsObject == null ? null :
      new Digest.fromJsObject(jsObject);
  Digest.fromJsObject(js.JsObject jsObject) : super.fromJsObject(jsObject);
  String get algorithm => $unsafe['algorithm'];

  Digest start() => Digest.$wrap($unsafe.callMethod('start'));
  Digest update(String message, {String encoding: 'raw'}) => Digest.$wrap(
      $unsafe.callMethod('update', [message, encoding]));
  ByteBuffer digest() => ByteBuffer.$wrap($unsafe.callMethod('digest'));
}
