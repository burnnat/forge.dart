library forge.gen.util;

import 'dart:js' as js;

import 'package:js_wrapping_generator/dart_generator.dart';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

@wrapper
abstract class ByteBuffer {
  int length();
  bool isEmpty();

  String getBytes([int count]);
  String toHex();

  static ByteBuffer $wrap(js.JsObject obj) => null;
}
