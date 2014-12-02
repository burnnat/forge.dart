library forge.tls_test;

import 'dart:async';

import 'package:unittest/unittest.dart';
import 'package:forge/forge.dart';

KeyPair createKeys(String cn) {
  int bits = 32;
  logMessage('Generating $bits-bit keypair for "$cn"...');

  KeyPair keys = pki.rsa.generateKeyPair(bits: bits);
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

abstract class TestHandler extends TlsHandler {

  final String heartbeatData = 'heartbeat_data';
  final String clientData = 'Hello Server!';
  final String serverData = 'Hello Client!';

  final String hostname;
  final String certPem;
  final String keyPem;

  final Function callback;

  TestHandler(this.hostname, this.certPem, this.keyPem)
    : callback = expectAsync((){});

  void log(String message) {
    logMessage('${hostname} :: ${message}');
  }

  bool verify(TlsConnection c, bool verified, int depth, List<Certificate> certs) {
    String cn = certs.first.subject.getField('CN').value;

    log('Verifying certificate for CN: "$cn"');
    log('Verified: $verified');

    expect(verified, isTrue);

    return verified;
  }

  String getCertificate(TlsConnection c, Object hint) {
    log('Getting certificate...');
    return certPem;
  }

  String getPrivateKey(TlsConnection c, Certificate cert) {
    log('Getting key...');
    return keyPem;
  }

  void heartbeatReceived(TlsConnection c, ByteBuffer payload) {
    String data = payload.getBytes();
    log('Received heartbeat: $data');
    expect(data, equals(heartbeatData));
  }

  void closed(TlsConnection c) {
    log('Disconnected.');
    callback();
  }

  void error(TlsConnection c, TlsError error) {
    log('Error: ${error.message}');
    fail('Encountered error in ${hostname}: ${error.message}');
  }
}

class ClientHandler extends TestHandler {

  TlsConnection server;

  ClientHandler(String certPem, String keyPem)
    : super('client', certPem, keyPem);

  void connected(TlsConnection c) {
    log('Connected...');

    new Future.delayed(
      const Duration(milliseconds: 100),
      () {
        c.prepareHeartbeatRequest(heartbeatData);
        c.prepare(clientData);
      }
    );
  }

  void tlsDataReady(TlsConnection c) {
    server.process(c.tlsData.getBytes());
  }

  void dataReady(TlsConnection c) {
    String response = c.data.getBytes();

    log('Received "$response"');
    expect(response, equals(serverData));

    c.close();
  }
}

class ServerHandler extends TestHandler {

  TlsConnection client;

  ServerHandler(String certPem, String keyPem)
    : super('server', certPem, keyPem);

  void connected(TlsConnection c) {
    log('Connected...');
    c.prepareHeartbeatRequest(heartbeatData);
  }

  void tlsDataReady(TlsConnection c) {
    client.process(c.tlsData.getBytes());
  }

  void dataReady(TlsConnection c) {
    var response = c.data.getBytes();

    log('Received "$response"');
    c.prepare(serverData);

    c.close();
  }
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

      ClientHandler clientHandler = new ClientHandler(
        clientCertPem,
        clientKeyPem
      );

      ServerHandler serverHandler = new ServerHandler(
        serverCertPem,
        serverKeyPem
      );

      TlsConnection client, server;

      client = tls.createConnection(
        clientHandler,
        server: false,
        caStore: [serverCertPem],
        cipherSuites: [
          CipherSuites.TLS_RSA_WITH_AES_128_CBC_SHA,
          CipherSuites.TLS_RSA_WITH_AES_256_CBC_SHA
        ],
        virtualHost: 'server'
      );

      server = tls.createConnection(
        serverHandler,
        server: true,
        caStore: [clientCertPem],
        cipherSuites: [
          CipherSuites.TLS_RSA_WITH_AES_128_CBC_SHA,
          CipherSuites.TLS_RSA_WITH_AES_256_CBC_SHA
        ],
        verifyClient: true
      );

      clientHandler.server = server;
      serverHandler.client = client;

      client.handshake(null);
    });
  });
}
