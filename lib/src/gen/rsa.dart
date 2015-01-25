library forge.gen.rsa;

import 'jsbn.dart';
import 'package:quiver/collection.dart';
import 'package:quiver/core.dart';
import 'dart:js' as js;
import 'package:js_wrapping/js_wrapping.dart' as jsw;

class KeyPair extends jsw.TypedJsObject {
  static KeyPair $wrap(js.JsObject jsObject) => jsObject == null ? null :
      new KeyPair.fromJsObject(jsObject);
  KeyPair.fromJsObject(js.JsObject jsObject) : super.fromJsObject(jsObject);
  PrivateKey get privateKey => PrivateKey.$wrap($unsafe['privateKey']);
  PublicKey get publicKey => PublicKey.$wrap($unsafe['publicKey']);
}

class PrivateKey extends jsw.TypedJsObject {
  static PrivateKey $wrap(js.JsObject jsObject) => jsObject == null ? null :
      new PrivateKey.fromJsObject(jsObject);
  PrivateKey.fromJsObject(js.JsObject jsObject) : super.fromJsObject(jsObject);
  String decrypt(String data, {String scheme: 'RSAES-PKCS1-V1_5', Object
      schemeOptions}) => $unsafe.callMethod('decrypt', [data, scheme, jsw.jsify(
      schemeOptions)]);

  String sign(Object digest, {String scheme: 'RSASSA-PKCS1-V1_5'}) =>
      $unsafe.callMethod('sign', [jsw.jsify(digest), scheme]);

  BigInteger get n => BigInteger.$wrap($unsafe['n']);
  BigInteger get e => BigInteger.$wrap($unsafe['e']);
  BigInteger get d => BigInteger.$wrap($unsafe['d']);
  BigInteger get p => BigInteger.$wrap($unsafe['p']);
  BigInteger get q => BigInteger.$wrap($unsafe['q']);
  BigInteger get dP => BigInteger.$wrap($unsafe['dP']);
  BigInteger get dQ => BigInteger.$wrap($unsafe['dQ']);
  BigInteger get qInv => BigInteger.$wrap($unsafe['qInv']);

  List<BigInteger> get _components => [n, e, d, p, q, dP, dQ, qInv];

  bool operator ==(o) => o is PrivateKey && listsEqual(_components,
      o._components);
  int get hashCode => hashObjects(_components);
}

class PublicKey extends jsw.TypedJsObject {
  static PublicKey $wrap(js.JsObject jsObject) => jsObject == null ? null :
      new PublicKey.fromJsObject(jsObject);
  PublicKey.fromJsObject(js.JsObject jsObject) : super.fromJsObject(jsObject);
  String encrypt(String data, {String scheme: 'RSAES-PKCS1-V1_5', Object
      schemeOptions}) => $unsafe.callMethod('encrypt', [data, scheme, jsw.jsify(
      schemeOptions)]);

  String verify(Object digest, String signature, {String scheme:
      'RSASSA-PKCS1-V1_5'}) => $unsafe.callMethod('verify', [jsw.jsify(digest),
      signature, scheme]);

  BigInteger get n => BigInteger.$wrap($unsafe['n']);
  BigInteger get e => BigInteger.$wrap($unsafe['e']);

  bool operator ==(o) => o is PublicKey && n == o.n && e == o.e;
  int get hashCode => hash2(n, e);
}
