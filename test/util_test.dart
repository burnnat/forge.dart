library forge.util_test;

import 'dart:typed_data';

import 'package:unittest/unittest.dart';
import 'package:forge/forge.dart' as forge;

void runTests() {
  group('ByteBuffer', () {
    test('can be created from ArrayBuffers', () {
      Uint8List bytes = new Uint8List.fromList([
        0x74,
        0x65,
        0x73,
        0x74,
        0x69,
        0x6e,
        0x67,
      ]);

      forge.ByteBuffer buffer = new forge.ByteBuffer.fromData(bytes);

      expect(buffer.length(), equals(7));
      expect(buffer.getBytes(), equals('testing'));
    });
  });
}
