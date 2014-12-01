library forge.tls;

import 'dart:js';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

import 'pki.dart';

import 'gen/tls.dart';
import 'gen/aes_suites.dart';
import 'gen/util.dart';

export 'gen/tls.dart';

JsObject _tls() => context['forge']['tls'];
final ForgeTls tls = new ForgeTls._();

class ForgeTls {
  ForgeTls._();

  TlsConnection createConnection(
    TlsHandler handler,
    {
      bool server: false,
      String sessionId: null,
      Map<String, Object> sessionCache: null,
      List<String> caStore: null, // or List<Certificate>
      List<CipherSuite> cipherSuites: null,
      String virtualHost: null,
      bool verifyClient: false,
      TlsCompressor compressor
    }
  ) {
    Map<String, Object> options = {
      'server': server,
      'sessionId': sessionId,
      'sessionCache': sessionCache,
      'caStore': caStore,
      'cipherSuites': cipherSuites,
      'virtualHost': virtualHost,
      'verify': _verify(handler),
      'verifyClient': verifyClient,
      'getCertificate': _getCertificate(handler),
      'getPrivateKey': _getPrivateKey(handler),
      // 'getSignature': handler.getSignature,
      'deflate': compressor != null
        ? _reflate(compressor.deflate)
        : null,
      'inflate': compressor != null
        ? _reflate(compressor.inflate)
        : null,
      'connected': _handler(handler.connected),
      'heartbeatReceived': _heartbeatReceived(handler),
      'tlsDataReady': _handler(handler.tlsDataReady),
      'dataReady': _handler(handler.dataReady),
      'closed': _handler(handler.closed),
      'error': _error(handler)
    };

    return TlsConnection.$wrap(
      _tls().callMethod(
        'createConnection',
        [jsw.jsify(options)]
      )
    );
  }

  Function _verify(TlsHandler handler)
    => (JsObject connection, bool verified, int depth, List<JsObject> chain)
      => handler.verify(
        TlsConnection.$wrap(connection),
        verified,
        depth,
        new List.from(chain.map((cert) => Certificate.$wrap(cert)))
      );

  Function _handler(_EventHandler handler)
    => (JsObject connection)
      => handler(
        TlsConnection.$wrap(connection)
      );

  Function _reflate(_Compressor reflater)
    => (JsObject fragment)
      => reflater(
        ByteBuffer.$wrap(fragment)
      );

  Function _getCertificate(TlsHandler handler)
    => (JsObject connection, Object hint)
      => handler.getCertificate(
        TlsConnection.$wrap(connection),
        hint
      );

  Function _getPrivateKey(TlsHandler handler)
    => (JsObject connection, JsObject cert)
      => handler.getPrivateKey(
        TlsConnection.$wrap(connection),
        Certificate.$wrap(cert)
      );

  Function _heartbeatReceived(TlsHandler handler)
    => (JsObject connection, JsObject payload)
      => handler.heartbeatReceived(
        TlsConnection.$wrap(connection),
        ByteBuffer.$wrap(payload)
      );

  Function _error(TlsHandler handler)
    => (JsObject connection, JsObject error)
      => handler.error(
        TlsConnection.$wrap(connection),
        TlsError.$wrap(error)
      );
}

typedef void _EventHandler(
  TlsConnection connection
);

abstract class TlsHandler {

  bool verify(
    TlsConnection connection,
    bool verified,
    int depth,
    List<Certificate> chain
  );

  String getCertificate(
    TlsConnection connection,
    Object hint
  );

  String getPrivateKey(
    TlsConnection connection,
    Certificate cert
  );

  // String getSignature();

  void connected(TlsConnection connection);

  void heartbeatReceived(
    TlsConnection connection,
    ByteBuffer payload
  );

  void tlsDataReady(TlsConnection connection);
  void dataReady(TlsConnection connection);
  void closed(TlsConnection connection);
  void error(TlsConnection connection, TlsError error);
}

typedef ByteBuffer _Compressor(
  ByteBuffer data
);

abstract class TlsCompressor {
  ByteBuffer deflate(ByteBuffer fragment);
  ByteBuffer inflate(ByteBuffer fragment);
}

class CipherSuites {
  static JsObject get _unsafe => _tls()['CipherSuites'];

  static CipherSuite get TLS_RSA_WITH_AES_128_CBC_SHA
    => CipherSuite.$wrap(_unsafe['TLS_RSA_WITH_AES_128_CBC_SHA']);
  static CipherSuite get TLS_RSA_WITH_AES_256_CBC_SHA
    => CipherSuite.$wrap(_unsafe['TLS_RSA_WITH_AES_256_CBC_SHA']);
}
