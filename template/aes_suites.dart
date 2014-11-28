library forge.gen.aes_suites;

import 'dart:js' as js;

import 'package:js_wrapping_generator/dart_generator.dart';
import 'package:js_wrapping/js_wrapping.dart' as jsw;

@wrapper
abstract class CipherSuite {
  List<int> get id;
  String get name;
}
