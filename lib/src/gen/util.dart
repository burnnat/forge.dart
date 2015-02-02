library forge.gen.util;

import 'dart:typed_data' as types;
import 'dart:js' as js;
import 'package:js_wrapping/js_wrapping.dart' as jsw;

class ByteBuffer extends jsw.TypedJsObject {
  static ByteBuffer $wrap(js.JsObject jsObject) => jsObject == null ? null :
      new ByteBuffer.fromJsObject(jsObject);
  ByteBuffer.fromJsObject(js.JsObject jsObject) : super.fromJsObject(jsObject);
  ByteBuffer.fromString(String data) : super(
      js.context['forge']['util']['ByteBuffer'], [data]);

  ByteBuffer.fromBuffer(types.ByteBuffer data) : super(
      js.context['forge']['util']['ByteBuffer'], [jsw.jsify(data)]);

  ByteBuffer.clone(ByteBuffer data) : super(
      js.context['forge']['util']['ByteBuffer'], [data == null ? null : data.$unsafe]
      );

  int length() => $unsafe.callMethod('length');
  bool isEmpty() => $unsafe.callMethod('isEmpty');

  String getBytes([int count]) => $unsafe.callMethod('getBytes', [count]);
  String toHex() => $unsafe.callMethod('toHex');

  int getByte() => $unsafe.callMethod('getByte');
}
