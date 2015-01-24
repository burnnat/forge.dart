library forge.pki;

import 'dart:js';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

import 'rsa.dart' as pki_rsa;
import 'gen/x509.dart';

export 'rsa.dart';
export 'gen/x509.dart';

JsObject _pki() => context['forge']['pki'];
final ForgePki pki = new ForgePki._();

class ForgePki {
  ForgePki._();

  final pki_rsa.ForgePkiRsa rsa = pki_rsa.rsa;

  Certificate createCertificate() {
    return Certificate.$wrap(
      _pki().callMethod('createCertificate', [])
    );
  }

  String certificateToPem(Certificate cert, [int maxline = 64])
    => _pki().callMethod('certificateToPem', [jsw.jsify(cert), maxline]);

  String privateKeyToPem(pki_rsa.PrivateKey key, [int maxline = 64])
    => _pki().callMethod('privateKeyToPem', [jsw.jsify(key), maxline]);

  Certificate certificateFromPem(String pem, { bool computeHash: false, bool strict: true })
    => _pki().callMethod('certificateFromPem', [pem, computeHash, strict]);

  pki_rsa.PrivateKey privateKeyFromPem(String pem)
    => _pki().callMethod('privateKeyFromPem', [pem]);
}
