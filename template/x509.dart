library forge.gen.x509;

import 'dart:js' as js;

import 'package:js_wrapping_generator/dart_generator.dart';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

@wrapper
abstract class Certificate extends jsw.TypedJsObject {
  int get version;
  String serialNumber;
  dynamic publicKey;

  Validity get validity => Validity.$wrap($unsafe['validity']);
  set validity(Validity validity);

  CertEntity get subject => CertEntity.$wrap($unsafe['subject']);
  void setSubject(List<CertAttribute> attrs, [String uniqueId]);

  CertEntity get issuer => CertEntity.$wrap($unsafe['issuer']);
  void setIssuer(List<CertAttribute> attrs, [String uniqueId]);

  void setExtensions(List<Map<String, Object>> extensions);
  void sign(dynamic privateKey, [digest]);
}

@wrapper
abstract class Validity {
  DateTime notBefore;
  DateTime notAfter;

  static Validity $wrap(js.JsObject obj) => null;
}

@wrapper
abstract class CertEntity {
  CertAttribute getField(String name);
  void addField(CertAttribute attr);

  static CertEntity $wrap(js.JsObject obj) => null;
}

@wrapper
abstract class CertAttribute extends jsw.TypedJsObject {
  String name;
  String shortName;
  String value;

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