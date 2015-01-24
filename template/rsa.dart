library forge.gen.rsa;

import 'dart:js' as js;

import 'package:js_wrapping_generator/dart_generator.dart';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

@wrapper
abstract class KeyPair extends jsw.TypedJsObject {
  PrivateKey get privateKey => PrivateKey.$wrap($unsafe['privateKey']);
  PublicKey get publicKey => PublicKey.$wrap($unsafe['publicKey']);
}

@wrapper
abstract class PrivateKey {
  String decrypt(String data, {
    String scheme: 'RSAES-PKCS1-V1_5',
    Object schemeOptions
  });

  String sign(Object digest, {
    String scheme: 'RSASSA-PKCS1-V1_5'
  });

  static PrivateKey $wrap(js.JsObject obj) => null;
}

@wrapper
abstract class PublicKey {
  String encrypt(String data, {
    String scheme: 'RSAES-PKCS1-V1_5',
    Object schemeOptions
  });

  String verify(
    Object digest,
    String signature,
    { String scheme: 'RSASSA-PKCS1-V1_5' }
  );

  static PublicKey $wrap(js.JsObject obj) => null;
}
