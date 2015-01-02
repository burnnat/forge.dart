library forge.gen.tls;

import 'dart:js' as js;

import 'package:js_wrapping/js_wrapping.dart' as jsw;

import 'util.dart';

class TlsConnection extends jsw.TypedJsObject {
  static TlsConnection $wrap(js.JsObject jsObject) => jsObject == null ? null : new TlsConnection.fromJsObject(jsObject);
  TlsConnection.fromJsObject(js.JsObject jsObject)
      : super.fromJsObject(jsObject);

  ByteBuffer get data => ByteBuffer.$wrap($unsafe['data']);
  ByteBuffer get tlsData => ByteBuffer.$wrap($unsafe['tlsData']);

  bool get open => $unsafe['open'];

  void reset({clearFail: true}) {
    $unsafe.callMethod('reset', [jsw.jsify(clearFail)]);
  }

  void handshake(String sessionId) {
    $unsafe.callMethod('handshake', [sessionId]);
  }

  int process(String data) => $unsafe.callMethod('process', [data]);

  bool prepare(String data) => $unsafe.callMethod('prepare', [data]);

  bool prepareHeartbeatRequest(payload, [payloadLength]) {
    List<Object> args = [payload];

    // JS method directly checks for undefined, not null, so if not specified,
    // we need to explicitly omit it from the arguments list.
    if (payloadLength != null) {
      args.add(payloadLength);
    }

    return $unsafe.callMethod(
    'prepareHeartbeatRequest',
    new List.from(args.map((obj) => jsw.jsify(obj)))
    );
  }

  void close({clearFail: true}) {
    $unsafe.callMethod('close', [jsw.jsify(clearFail)]);
  }
}

class TlsError extends jsw.TypedJsObject {
  static TlsError $wrap(js.JsObject jsObject) => jsObject == null ? null : new TlsError.fromJsObject(jsObject);
  TlsError.fromJsObject(js.JsObject jsObject)
      : super.fromJsObject(jsObject);
  String get message => $unsafe['message'];
  bool get send => $unsafe['send'];
}
