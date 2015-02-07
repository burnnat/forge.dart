library forge.gen.util;

import 'dart:js' as js;
import 'dart:typed_data';

import 'package:js_wrapping_generator/dart_generator.dart';

@wrapper
@Module('forge.util')
abstract class ByteBuffer {
  @generate
  ByteBuffer.fromString(String data);

  @generate
  ByteBuffer.clone(ByteBuffer data);

  @generate
  ByteBuffer._fromRaw(dynamic data);

  ByteBuffer.fromData(TypedData data)
    // Dart2js does not pass through typed_data.ByteBuffers as javascript ArrayBuffers,
    // so we need to do a little workaround to massage the dart data into an acceptable
    // form. This is no doubt inefficient for large data sizes, but for now it works.
    : this._fromRaw(new js.JsObject(js.context['Uint8Array'], [data])['buffer']);

  int length();
  bool isEmpty();

  String getBytes([int count]);
  String toHex();

  int getByte();
}
