library forge.gen.aes_suites;

import 'package:js_wrapping_generator/dart_generator.dart';

@wrapper
abstract class CipherSuite {
  List<int> get id;
  String get name;
}
