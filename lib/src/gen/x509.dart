library forge.gen.x509;

import 'dart:js' as js;

import 'package:js_wrapping/js_wrapping.dart' as jsw;

class Certificate extends jsw.TypedJsObject {
  static Certificate $wrap(js.JsObject jsObject) => jsObject == null ? null : new Certificate.fromJsObject(jsObject);
  Certificate.fromJsObject(js.JsObject jsObject)
      : super.fromJsObject(jsObject);
  int get version => $unsafe['version'];
  set serialNumber(String serialNumber) => $unsafe['serialNumber'] = serialNumber;
  String get serialNumber => $unsafe['serialNumber'];
  set publicKey(dynamic publicKey) => $unsafe['publicKey'] = jsw.jsify(publicKey);
  dynamic get publicKey => $unsafe['publicKey'];
  set validity(Validity validity) => $unsafe['validity'] = validity == null ? null : validity.$unsafe;
  Validity get validity => Validity.$wrap($unsafe['validity']);

  void setSubject(List<CertAttribute> attrs, [String uniqueId]) {
    $unsafe.callMethod('setSubject', [jsw.jsify(attrs), uniqueId]);
  }
  void setIssuer(List<CertAttribute> attrs, [String uniqueId]) {
    $unsafe.callMethod('setIssuer', [jsw.jsify(attrs), uniqueId]);
  }
  void setExtensions(List<Map<String, Object>> extensions) {
    $unsafe.callMethod('setExtensions', [jsw.jsify(extensions)]);
  }

  void sign(dynamic privateKey, [digest]) {
    $unsafe.callMethod('sign', [jsw.jsify(privateKey), jsw.jsify(digest)]);
  }
}

class Validity extends jsw.TypedJsObject {
  static Validity $wrap(js.JsObject jsObject) => jsObject == null ? null : new Validity.fromJsObject(jsObject);
  Validity.fromJsObject(js.JsObject jsObject)
      : super.fromJsObject(jsObject);
  set notBefore(DateTime notBefore) => $unsafe['notBefore'] = notBefore;
  DateTime get notBefore => $unsafe['notBefore'];
  set notAfter(DateTime notAfter) => $unsafe['notAfter'] = notAfter;
  DateTime get notAfter => $unsafe['notAfter'];
}

class CertAttribute extends jsw.TypedJsObject {
  static CertAttribute $wrap(js.JsObject jsObject) => jsObject == null ? null : new CertAttribute.fromJsObject(jsObject);
  CertAttribute.fromJsObject(js.JsObject jsObject)
      : super.fromJsObject(jsObject);
  set name(String name) => $unsafe['name'] = name;
  String get name => $unsafe['name'];
  set shortName(String shortName) => $unsafe['shortName'] = shortName;
  String get shortName => $unsafe['shortName'];
  set value(String value) => $unsafe['value'] = value;
  String get value => $unsafe['value'];
  CertAttribute.withFullName(String name, String value)
      : super.fromJsObject(
      jsw.jsify({
        'name': name,
        'value': value
      })
      );

  CertAttribute.withShortName(String shortName, String value)
      : super.fromJsObject(
      jsw.jsify({
        'shortName': shortName,
        'value': value
      })
      );
}
