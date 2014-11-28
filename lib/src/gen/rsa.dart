library forge.gen.rsa;

import 'dart:js' as js;

import 'package:js_wrapping/js_wrapping.dart' as jsw;

class KeyPair extends jsw.TypedJsObject {
  static KeyPair $wrap(js.JsObject jsObject) => jsObject == null ? null : new KeyPair.fromJsObject(jsObject);
  KeyPair.fromJsObject(js.JsObject jsObject)
      : super.fromJsObject(jsObject);
  set privateKey(PrivateKey privateKey) => $unsafe['privateKey'] = jsw.jsify(privateKey);
  PrivateKey get privateKey => $unsafe['privateKey'];
  set publicKey(PublicKey publicKey) => $unsafe['publicKey'] = jsw.jsify(publicKey);
  PublicKey get publicKey => $unsafe['publicKey'];
}

class PrivateKey extends jsw.TypedJsObject {
  static PrivateKey $wrap(js.JsObject jsObject) => jsObject == null ? null : new PrivateKey.fromJsObject(jsObject);
  PrivateKey.fromJsObject(js.JsObject jsObject)
      : super.fromJsObject(jsObject);
  String decrypt(String data, {String scheme: 'RSAES-PKCS1-V1_5', Object schemeOptions}) => $unsafe.callMethod('decrypt', [data, scheme, jsw.jsify(schemeOptions)]);

  String sign(Object digest, {String scheme: 'RSASSA-PKCS1-V1_5'}) => $unsafe.callMethod('sign', [jsw.jsify(digest), scheme]);
}

class PublicKey extends jsw.TypedJsObject {
  static PublicKey $wrap(js.JsObject jsObject) => jsObject == null ? null : new PublicKey.fromJsObject(jsObject);
  PublicKey.fromJsObject(js.JsObject jsObject)
      : super.fromJsObject(jsObject);
  String encrypt(String data, {String scheme: 'RSAES-PKCS1-V1_5', Object schemeOptions}) => $unsafe.callMethod('encrypt', [data, scheme, jsw.jsify(schemeOptions)]);

  String verify(Object digest, String signature, {String scheme: 'RSASSA-PKCS1-V1_5'}) => $unsafe.callMethod('verify', [jsw.jsify(digest), signature, scheme]);
}
