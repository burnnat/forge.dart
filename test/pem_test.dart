library forge.pem_test;

import 'package:unittest/unittest.dart';
import 'package:forge/forge.dart';

void runTests() {
  group('PEM', () {
    test('converts certificates', () {
      Certificate cert = pki.createCertificate();

      cert.serialNumber = '01';

      DateTime now = new DateTime.now();
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

      String pem = pki.certificateToPem(cert);
      Certificate parsed = pki.certificateFromPem(pem);

      expect(cert.serialNumber, equals(parsed.serialNumber));
    });
  });
}
