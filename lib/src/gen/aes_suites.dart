library forge.gen.aes_suites;

import 'dart:js' as js;

import 'package:js_wrapping/js_wrapping.dart' as jsw;

class CipherSuite extends jsw.TypedJsObject {
  static CipherSuite $wrap(js.JsObject jsObject) => jsObject == null ? null : new CipherSuite.fromJsObject(jsObject);
  CipherSuite.fromJsObject(js.JsObject jsObject)
      : super.fromJsObject(jsObject);
  List<int> get id => jsw.TypedJsArray.$wrap($unsafe['id']);
  String get name => $unsafe['name'];
}
