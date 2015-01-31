library forge.gen.asn1;
import 'dart:js' as js;
import 'package:js_wrapping/js_wrapping.dart' as jsw;

class Asn1 extends jsw.TypedJsObject {
  static Asn1 $wrap(js.JsObject jsObject) => jsObject == null ? null :
      new Asn1.fromJsObject(jsObject);
  Asn1.fromJsObject(js.JsObject jsObject) : super.fromJsObject(jsObject);
  int get tagClass => $unsafe['tagClass'];
  int get type => $unsafe['type'];
  bool get constructed => $unsafe['constructed'];
  bool get composed => $unsafe['composed'];
  Object get value => $unsafe['value'];
}
