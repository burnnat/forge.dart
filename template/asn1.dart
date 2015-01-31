library forge.gen.asn1;

import 'package:js_wrapping_generator/dart_generator.dart';

@wrapper
abstract class Asn1 {
  int get tagClass;
  int get type;
  bool get constructed;
  bool get composed;
  Object get value;
}
