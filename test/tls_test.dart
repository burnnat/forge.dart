library forge.tls_test;

import 'dart:async';

import 'package:unittest/unittest.dart';
import 'package:forge/forge.dart';

KeyPair createKeys(String cn) {
  logMessage('Generating 512-bit keypair for "$cn"...');

  KeyPair keys = pki.rsa.generateKeyPair(bits: 512);
  expect(keys, isNotNull);

  logMessage('Key pair generated.');
  return keys;
}

Certificate createCert(KeyPair keys, String cn) {
  logMessage('Generating certificate for "$cn"...');

  Certificate cert = pki.createCertificate();
  expect(cert, isNotNull);

  cert.serialNumber = '01';

  DateTime now = new DateTime.now();

  cert.validity.notBefore = now;
  cert.validity.notAfter = now.add(new Duration(days: 30));

  List<CertAttribute> attrs = [
    new CertAttribute.withFullName('commonName', cn),
    new CertAttribute.withFullName('countryName', 'US'),
    new CertAttribute.withShortName('ST', 'Virginia'),
    new CertAttribute.withFullName('localityName', 'Blacksburg'),
    new CertAttribute.withFullName('organizationName', 'Test'),
    new CertAttribute.withShortName('OU', 'Test')
  ];

  cert.setSubject(attrs);
  cert.setIssuer(attrs);

  cert.setExtensions([
    {
      'name': 'basicConstraints',
      'cA': true
    },
    {
      'name': 'keyUsage',
      'keyCertSign': true,
      'digitalSignature': true,
      'nonRepudiation': true,
      'keyEncipherment': true,
      'dataEncipherment': true
    },
    {
      'name': 'subjectAltName',
      'altNames': [{
        'type': 6, // URI
        'value': 'http://myuri.com/webid#me'
      }]
    }
  ]);

  cert.publicKey = keys.publicKey;

  cert.sign(keys.privateKey);
  logMessage('Certificate created for "$cn".');

  return cert;
}

String keyPem(KeyPair keys) {
  String pem = pki.privateKeyToPem(keys.privateKey);
  expect(pem, hasLength(greaterThan(0)));
  return pem;
}

String certPem(Certificate cert) {
  String pem = pki.certificateToPem(cert);
  expect(pem, hasLength(greaterThan(0)));
  return pem;
}

void runTests() {
  group('TLS', () {
    test('connects successfully', () {
      // Initialize server credentials
      String serverCn = 'server';
      KeyPair serverKeys = createKeys(serverCn);
      Certificate serverCert = createCert(serverKeys, serverCn);

      String serverKeyPem = keyPem(serverKeys);
      String serverCertPem = certPem(serverCert);

      // Initialize client credentials
      String clientCn = 'client';
      KeyPair clientKeys = createKeys(clientCn);
      Certificate clientCert = createCert(clientKeys, clientCn);

      String clientKeyPem = keyPem(clientKeys);
      String clientCertPem = certPem(clientCert);

      TlsConnection client, server;

      client = tls.createConnection(
        server: false,
        caStore: [serverCertPem],
        cipherSuites: [
          CipherSuites.TLS_RSA_WITH_AES_128_CBC_SHA,
          CipherSuites.TLS_RSA_WITH_AES_256_CBC_SHA
        ],
        virtualHost: 'server',

        verify: (TlsConnection c, bool verified, int depth, List<Certificate> certs) {
          String cn = certs.first.subject.getField('CN').value;

          logMessage('TLS Client verifying certificate w/CN: "$cn"');
          logMessage('Verified: $verified...');

          return verified;
        },

        connected: (TlsConnection c) {
          logMessage('Client connected...');

          new Future.delayed(
            const Duration(milliseconds: 10),
            () {
              c.prepareHeartbeatRequest('heartbeat');
              c.prepare('Hello Server');
            }
          );
        },

        getCertificate: (TlsConnection c, Object hint) {
          logMessage('Client getting certificate...');
          return clientCertPem;
        },

        getPrivateKey: (TlsConnection c, Certificate cert) {
          return clientKeyPem;
        },

        tlsDataReady: (TlsConnection c) {
          server.process(c.tlsData.getBytes());
        },

        dataReady: (TlsConnection c) {
          var response = c.data.getBytes();
          logMessage('Client received "$response"');
          expect(response, equals('Hello Client'));
          c.close();
        },

        heartbeatReceived: (TlsConnection c, ByteBuffer payload) {
          logMessage('Client received heartbeat: ${payload.getBytes()}');
        },

        closed: (TlsConnection c) {
          logMessage('Client disconnected.');
        },

        error: (TlsConnection c, TlsError error) {
          logMessage('Client error: ${error.message}');
        }
      );
    });
  });
}
