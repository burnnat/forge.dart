library forge.gen.util;

import 'package:js_wrapping_generator/dart_generator.dart';

@wrapper
abstract class ByteBuffer {
  int length();
  bool isEmpty();

  String getBytes([int count]);
  String toHex();
}
