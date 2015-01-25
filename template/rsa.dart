library forge.gen.rsa;

import 'jsbn.dart';
import 'package:quiver/collection.dart';
import 'package:quiver/core.dart';

import 'package:js_wrapping_generator/dart_generator.dart';

@wrapper
abstract class KeyPair {
  PrivateKey get privateKey;
  PublicKey get publicKey;
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

  BigInteger get n;
  BigInteger get e;
  BigInteger get d;
  BigInteger get p;
  BigInteger get q;
  BigInteger get dP;
  BigInteger get dQ;
  BigInteger get qInv;

  List<BigInteger> get _components => [n, e, d, p, q, dP, dQ, qInv];

  bool operator ==(o) => o is PrivateKey && listsEqual(_components, o._components);
  int get hashCode => hashObjects(_components);
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

  BigInteger get n;
  BigInteger get e;

  bool operator ==(o) => o is PublicKey && n == o.n && e == o.e;
  int get hashCode => hash2(n, e);
}
