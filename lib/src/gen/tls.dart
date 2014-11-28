import 'dart:js' as js;

import 'package:js_wrapping_generator/dart_generator.dart';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

class TlsConnection extends jsw.TypedJsObject {
  static TlsConnection $wrap(js.JsObject jsObject) => jsObject == null ? null : new TlsConnection.fromJsObject(jsObject);
  TlsConnection.fromJsObject(js.JsObject jsObject)
      : super.fromJsObject(jsObject);
  void reset({clearFail: true}) {
    $unsafe.callMethod('reset', [jsw.jsify(clearFail)]);
  }
  void handshake(sessionId) {
    $unsafe.callMethod('handshake', [jsw.jsify(sessionId)]);
  }
}
