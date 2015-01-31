library forge.pki;

import 'dart:js';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

import 'rsa.dart' as pki_rsa;
import 'gen/asn1.dart';
import 'gen/x509.dart';

export 'rsa.dart';
export 'gen/asn1.dart';
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

  Certificate certificateFromPem(String pem, { bool computeHash: false, bool strict: true }) {
    return Certificate.$wrap(
      _pki().callMethod('certificateFromPem', [pem, computeHash, strict])
    );
  }

  pki_rsa.PrivateKey privateKeyFromPem(String pem) {
    return pki_rsa.PrivateKey.$wrap(
      _pki().callMethod('privateKeyFromPem', [pem])
    );
  }

  Asn1 certificateToAsn1(Certificate cert) {
    return Asn1.$wrap(
      _pki().callMethod('certificateToAsn1', [jsw.jsify(cert)])
    );
  }

  Asn1 privateKeyToAsn1(pki_rsa.PrivateKey key) {
    return Asn1.$wrap(
      _pki().callMethod('privateKeyToAsn1', [jsw.jsify(key)])
    );
  }

  Certificate certificateFromAsn1(Asn1 object, { bool computeHash: false }) {
    return Certificate.$wrap(
      _pki().callMethod('certificateFromAsn1', [jsw.jsify(object), computeHash])
    );
  }

  pki_rsa.PrivateKey privateKeyFromAsn1(Asn1 object) {
    return pki_rsa.PrivateKey.$wrap(
      _pki().callMethod('privateKeyFromAsn1', [jsw.jsify(object)])
    );
  }
}
