library forge.gen.util;

import 'dart:js' as js;

import 'package:js_wrapping/js_wrapping.dart' as jsw;

class ByteBuffer extends jsw.TypedJsObject {
  static ByteBuffer $wrap(js.JsObject jsObject) => jsObject == null ? null : new ByteBuffer.fromJsObject(jsObject);
  ByteBuffer.fromJsObject(js.JsObject jsObject)
      : super.fromJsObject(jsObject);
  int length() => $unsafe.callMethod('length');
  bool isEmpty() => $unsafe.callMethod('isEmpty');
  String getBytes([int count]) => $unsafe.callMethod('getBytes', [count]);
}
