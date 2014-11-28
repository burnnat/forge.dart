library forge.gen.rsa;

import 'dart:js' as js;

import 'package:js_wrapping_generator/dart_generator.dart';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

@wrapper
abstract class KeyPair {
  PrivateKey privateKey;
  PublicKey publicKey;
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
}
