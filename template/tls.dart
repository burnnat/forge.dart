library forge.gen.tls;

import 'package:js_wrapping_generator/dart_generator.dart';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

import 'util.dart';

@wrapper
abstract class TlsConnection extends jsw.TypedJsObject {

  ByteBuffer get data;
  ByteBuffer get tlsData;

  bool get open;

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
      'prepareHeartbeatRequest',
      new List.from(args.map((obj) => jsw.jsify(obj)))
    );
  }

  void close({ clearFail: true });
}

@wrapper
abstract class TlsError {
  String get message;
  bool get send;
}
