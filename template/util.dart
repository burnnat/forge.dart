library forge.gen.util;

import 'dart:typed_data' as types;

import 'package:js_wrapping_generator/dart_generator.dart';

@wrapper
@Module('forge.util')
abstract class ByteBuffer {
  @generate
  ByteBuffer.fromString(String data);

  @generate
  ByteBuffer.fromBuffer(types.ByteBuffer data);

  @generate
  ByteBuffer.clone(ByteBuffer data);

  int length();
  bool isEmpty();

  String getBytes([int count]);
  String toHex();

  int getByte();
}
