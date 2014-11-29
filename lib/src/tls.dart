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

typedef bool Verifier(
  TlsConnection connection,
  bool verified,
  int depth,
  List<Certificate> chain
);

typedef void EventHandler(
  TlsConnection connection
);

typedef String CertGetter(
  TlsConnection connection,
  Object hint
);

typedef String KeyGetter(
  TlsConnection connection,
  Certificate cert
);

typedef void HeartbeatReceiver(
  TlsConnection connection,
  ByteBuffer payload
);

typedef void ErrorHandler(
  TlsConnection connection,
  TlsError error
);

class ForgeTls {
  ForgeTls._();

  TlsConnection createConnection({
    bool server: false,
    String sessionId: null,
    Map<String, Object> sessionCache: null,
    List<String> caStore: null, // or List<Certificate>
    List<CipherSuite> cipherSuites: null,
    String virtualHost: null,
    Verifier verify: null,
    Function verifyClient: null,
    CertGetter getCertificate: null,
    KeyGetter getPrivateKey: null,
    Function getSignature: null,
    Function deflate: null,
    Function inflate: null,
    EventHandler connected: null,
    HeartbeatReceiver heartbeatReceived: null,
    EventHandler tlsDataReady: null,
    EventHandler dataReady: null,
    EventHandler closed: null,
    ErrorHandler error: null
  }) {
    Map<String, Object> options = {
      'server': server,
      'sessionId': sessionId,
      'sessionCache': sessionCache,
      'caStore': caStore,
      'cipherSuites': cipherSuites,
      'virtualHost': virtualHost,
      'verify': _verify(verify),
      'verifyClient': verifyClient,
      'getCertificate': _getCertificate(getCertificate),
      'getPrivateKey': _getPrivateKey(getPrivateKey),
      'getSignature': getSignature,
      'deflate': deflate,
      'inflate': inflate,
      'connected': _handler(connected),
      'heartbeatReceived': _heartbeatReceived(heartbeatReceived),
      'tlsDataReady': _handler(tlsDataReady),
      'dataReady': _handler(dataReady),
      'closed': _handler(closed),
      'error': _error(error)
    };

    return TlsConnection.$wrap(
      _tls().callMethod(
        'createConnection',
        [jsw.jsify(options)]
      )
    );
  }

  Function _verify(Verifier verifier)
    => (JsObject connection, bool verified, int depth, List<JsObject> chain)
      => verifier(
        TlsConnection.$wrap(connection),
        verified,
        depth,
        new List.from(chain.map((cert) => Certificate.$wrap(cert)))
      );

  Function _handler(EventHandler handler)
    => (JsObject connection)
      => handler(
        TlsConnection.$wrap(connection)
      );

  Function _getCertificate(CertGetter getter)
    => (JsObject connection, Object hint)
      => getter(
        TlsConnection.$wrap(connection),
        hint
      );

  Function _getPrivateKey(KeyGetter getter)
    => (JsObject connection, JsObject cert)
      => getter(
        TlsConnection.$wrap(connection),
        Certificate.$wrap(cert)
      );

  Function _heartbeatReceived(HeartbeatReceiver receiver)
    => (JsObject connection, JsObject payload)
      => receiver(
        TlsConnection.$wrap(connection),
        ByteBuffer.$wrap(payload)
      );

  Function _error(ErrorHandler handler)
    => (JsObject connection, JsObject error)
      => handler(
        TlsConnection.$wrap(connection),
        TlsError.$wrap(error)
      );
}

class CipherSuites {
  static JsObject get _unsafe => _tls()['CipherSuites'];

  static CipherSuite get TLS_RSA_WITH_AES_128_CBC_SHA
    => CipherSuite.$wrap(_unsafe['TLS_RSA_WITH_AES_128_CBC_SHA']);
  static CipherSuite get TLS_RSA_WITH_AES_256_CBC_SHA
    => CipherSuite.$wrap(_unsafe['TLS_RSA_WITH_AES_256_CBC_SHA']);
}
