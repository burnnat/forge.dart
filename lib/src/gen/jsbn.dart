library forge.gen.jsbn;

import 'package:quiver/core.dart';
import 'dart:js' as js;
import 'package:js_wrapping/js_wrapping.dart' as jsw;

class BigInteger extends jsw.TypedJsObject {
  static BigInteger $wrap(js.JsObject jsObject) => jsObject == null ? null :
      new BigInteger.fromJsObject(jsObject);
  BigInteger.fromJsObject(js.JsObject jsObject) : super.fromJsObject(jsObject);
  bool equals(BigInteger other) => $unsafe.callMethod('equals', [other == null ?
      null : other.$unsafe]);

  int get s => $unsafe['s'];
  int get t => $unsafe['t'];
  List<int> get data => jsw.TypedJsArray.$wrap($unsafe['data']);

  bool operator ==(o) => o is BigInteger && this.equals(o);
  int get hashCode => hash3(s, t, hashObjects(data.take(t)));
}
