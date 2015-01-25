library forge.gen.x509;

import 'rsa.dart';

import 'package:js_wrapping_generator/dart_generator.dart';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

@wrapper
abstract class Certificate {
  int get version;
  String serialNumber;
  PublicKey publicKey;

  Validity get validity;
  set validity(Validity validity);

  CertEntity get subject;
  void setSubject(List<CertAttribute> attrs, [String uniqueId]);

  CertEntity get issuer;
  void setIssuer(List<CertAttribute> attrs, [String uniqueId]);

  void setExtensions(List<Map<String, Object>> extensions);
  void sign(dynamic privateKey, [digest]);
}

@wrapper
abstract class Validity {
  DateTime notBefore;
  DateTime notAfter;
}

@wrapper
abstract class CertEntity {
  CertAttribute getField(String name);
  void addField(CertAttribute attr);
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