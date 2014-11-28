library forge.tls;

import 'dart:js';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

import 'gen/tls.dart';

TlsConnection createConnection({ server: false }) {
  Map<String, Object> options = new Map();

  options['server'] = server;

  return TlsConnection.$wrap(
    context['forge']['tls'].callMethod(
      'createConnection',
      [jsw.jsify(options)]
    )
  );
}
