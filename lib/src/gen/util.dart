library forge.gen.util;

import 'dart:js' as js;
import 'dart:typed_data';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

class ByteBuffer extends jsw.TypedJsObject {
  static ByteBuffer $wrap(js.JsObject jsObject) => jsObject == null ? null :
      new ByteBuffer.fromJsObject(jsObject);
  ByteBuffer.fromJsObject(js.JsObject jsObject) : super.fromJsObject(jsObject);
  ByteBuffer.fromString(String data) : super(
      js.context['forge']['util']['ByteBuffer'], [data]);

  ByteBuffer.clone(ByteBuffer data) : super(
      js.context['forge']['util']['ByteBuffer'], [data == null ? null : data.$unsafe]
      );

  ByteBuffer._fromRaw(dynamic data) : super(
      js.context['forge']['util']['ByteBuffer'], [jsw.jsify(data)]);

  ByteBuffer.fromData(TypedData data)
      // Dart2js does not pass through typed_data.ByteBuffers as javascript ArrayBuffers,
      // so we need to do a little workaround to massage the dart data into an acceptable
      // form. This is no doubt inefficient for large data sizes, but for now it works.
      : this._fromRaw(new js.JsObject(js.context['Uint8Array'], [data]
          )['buffer']);

  int length() => $unsafe.callMethod('length');
  bool isEmpty() => $unsafe.callMethod('isEmpty');

  String getBytes([int count]) => $unsafe.callMethod('getBytes', [count]);
  String toHex() => $unsafe.callMethod('toHex');

  int getByte() => $unsafe.callMethod('getByte');
}
