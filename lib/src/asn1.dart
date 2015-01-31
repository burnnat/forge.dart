library forge.pki;

import 'dart:js';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

import 'gen/asn1.dart';
import 'gen/util.dart';

JsObject _asn1() => context['forge']['asn1'];
final ForgeAsn1 asn1 = new ForgeAsn1._();

class ForgeAsn1 {
  ForgeAsn1._();

  ByteBuffer toDer(Asn1 object) {
    return ByteBuffer.$wrap(
      _asn1().callMethod('toDer', [jsw.jsify(object)])
    );
  }

  Asn1 fromDer(ByteBuffer bytes, { bool strict: true }) {
    return Asn1.$wrap(
      _asn1().callMethod('fromDer', [jsw.jsify(bytes), strict])
    );
  }
}
