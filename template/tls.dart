library forge.gen.tls;

import 'dart:js' as js;

import 'package:js_wrapping_generator/dart_generator.dart';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

@wrapper
abstract class TlsConnection extends jsw.TypedJsObject {
  void reset({ clearFail: true });

  void handshake(String sessionId);

  int process(String data);

  bool prepare(String data);

  bool prepareHeartbeatRequest(payload, [payloadLength]) {
    List<Object> args = [payload];

    // JS method directly checks for undefined, not null, so if not specified,
    // we need to explicitly omit it from the arguments list.
    if (payloadLength != null) {
      args.add(payloadLength);
    }

    return $unsafe.callMethod(
      'handshake',
      new List.from(args.map((obj) => jsw.jsify(obj)))
    );
  }

  void close({ clearFail: true });
}
