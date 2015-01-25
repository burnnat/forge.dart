library forge.pem_test;

import 'package:unittest/unittest.dart';
import 'package:forge/forge.dart';

void runTests() {
  group('PEM', () {
    KeyPair keys;
    Certificate cert;

    setUp(() {
      keys = pki.rsa.generateKeyPair(bits: 32);
      cert = pki.createCertificate();

      cert.serialNumber = '01';

      DateTime now = new DateTime.now();

      // PEM only stores down to the second, so we need to strip the milliseconds for comparison.
      now = now.subtract(new Duration(milliseconds: now.millisecond));

      cert.validity.notBefore = now;
      cert.validity.notAfter = now.add(new Duration(days: 30));

      List<CertAttribute> attrs = [
        new CertAttribute.withFullName('commonName', 'sample'),
        new CertAttribute.withFullName('countryName', 'US'),
        new CertAttribute.withShortName('ST', 'Virginia'),
        new CertAttribute.withFullName('localityName', 'Blacksburg'),
        new CertAttribute.withFullName('organizationName', 'Test'),
        new CertAttribute.withShortName('OU', 'Test')
      ];

      cert.setSubject(attrs);
      cert.setIssuer(attrs);

      cert.publicKey = keys.publicKey;
      cert.sign(keys.privateKey);
    });

    test('converts certificates', () {
      String pem = pki.certificateToPem(cert);
      Certificate parsed = pki.certificateFromPem(pem);

      expect(parsed.serialNumber, equals(cert.serialNumber));
      expect(parsed.validity.notBefore, equals(cert.validity.notBefore));
      expect(parsed.validity.notAfter, equals(cert.validity.notAfter));

      List<String> fields = ['CN', 'C', 'ST', 'L', 'O', 'OU'];

      void testFields(CertEntity actualEntity, CertEntity expectedEntity) {
        fields.forEach((field) {
          CertAttribute actual = actualEntity.getField(field);
          CertAttribute expected = expectedEntity.getField(field);

          expect(actual.value, equals(expected.value));
        });
      }

      testFields(parsed.subject, cert.subject);
      testFields(parsed.issuer, cert.issuer);

      expect(parsed.publicKey, equals(cert.publicKey));
    });

    test('converts certificates', () {
      String pem = pki.privateKeyToPem(keys.privateKey);
      PrivateKey parsed = pki.privateKeyFromPem(pem);

      expect(parsed, equals(keys.privateKey));
    });
  });
}
