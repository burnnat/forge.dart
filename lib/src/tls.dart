library forge.tls;

import 'dart:js';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

import 'gen/tls.dart';
import 'gen/aes_suites.dart';

export 'gen/tls.dart';

JsObject _tls() => context['forge']['tls'];
final ForgeTls tls = new ForgeTls._();

class ForgeTls {
  ForgeTls._();

  TlsConnection createConnection({
    bool server: false,
    String sessionId: null,
    Map<String, Object> sessionCache: null,
    List<String> caStore: null, // or List<Certificate>
    List<CipherSuite> cipherSuites: null,
    String virtualHost: null,
    Function verify: null,
    Function verifyClient: null,
    Function getCertificate: null,
    Function getPrivateKey: null,
    Function getSignature: null,
    Function deflate: null,
    Function inflate: null,
    Function connected: null,
    Function heartbeatReceived: null,
    Function tlsDataReady: null,
    Function dataReady: null,
    Function closed: null,
    Function error: null
  }) {
    Map<String, Object> options = {
      'server': server,
      'sessionId': sessionId,
      'sessionCache': sessionCache,
      'caStore': caStore,
      'cipherSuites': cipherSuites,
      'virtualHost': virtualHost,
      'verify': verify,
      'verifyClient': verifyClient,
      'getCertificate': getCertificate,
      'getPrivateKey': getPrivateKey,
      'getSignature': getSignature,
      'deflate': deflate,
      'inflate': inflate,
      'connected': connected,
      'heartbeatReceived': heartbeatReceived,
      'tlsDataReady': tlsDataReady,
      'dataReady': dataReady,
      'closed': closed,
      'error': error
    };

    return TlsConnection.$wrap(
      _tls().callMethod(
        'createConnection',
        [jsw.jsify(options)]
      )
    );
  }
}

class CipherSuites {
  static JsObject get _unsafe => _tls()['CipherSuites'];

  static CipherSuite get TLS_RSA_WITH_AES_128_CBC_SHA
    => CipherSuite.$wrap(_unsafe['TLS_RSA_WITH_AES_128_CBC_SHA']);
  static CipherSuite get TLS_RSA_WITH_AES_256_CBC_SHA
    => CipherSuite.$wrap(_unsafe['TLS_RSA_WITH_AES_256_CBC_SHA']);
}
