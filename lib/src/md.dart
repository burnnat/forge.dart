library forge.md;

import 'dart:js';

import 'gen/md.dart';
export 'gen/md.dart';

DigestAlgorithm _md(String algorithm)
  => DigestAlgorithm.$wrap(context['forge']['md'][algorithm]);

final ForgeMd md = new ForgeMd._();

class ForgeMd {
  ForgeMd._();

  DigestAlgorithm get md5 => _md('md5');

  DigestAlgorithm get sha1 => _md('sha1');
  DigestAlgorithm get sha256 => _md('sha256');
  DigestAlgorithm get sha384 => _md('sha384');
  DigestAlgorithm get sha512 => _md('sha512');
}