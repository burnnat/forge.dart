library forge.pki.rsa;

import 'dart:js';

import 'gen/rsa.dart';
export 'gen/rsa.dart';

JsObject _rsa() => context['forge']['pki']['rsa'];
final ForgePkiRsa rsa = new ForgePkiRsa._();

class ForgePkiRsa {
  ForgePkiRsa._();

  KeyPair generateKeyPair({
    int bits: 2048,
    int exponent: 0x10001,
    String workerScript,
    int workers: 2,
    int workLoad: 100,
    Object prng,
    String algorithm: 'PRIMEINC',
    Function callback
  }) {
    Map options = {
      'bits': bits,
      'e': exponent,
      'workerScript': workerScript,
      'workers': workers,
      'workLoad': workLoad,
      'prng': prng,
      'algorithm': algorithm
    };

    return KeyPair.$wrap(
      _rsa().callMethod('generateKeyPair', [options, callback])
    );
  }
}