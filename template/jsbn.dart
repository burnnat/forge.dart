library forge.gen.jsbn;

import 'package:quiver/core.dart';

import 'package:js_wrapping_generator/dart_generator.dart';

@wrapper
abstract class BigInteger {
  bool equals(BigInteger other);

  int get s;
  int get t;
  List<int> get data;

  bool operator ==(o) => o is BigInteger && this.equals(o);
  int get hashCode => hash3(s, t, hashObjects(data.take(t)));
}
