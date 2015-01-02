library forge.md_test;

import 'package:unittest/unittest.dart';
import 'package:forge/forge.dart';

class DataSet {
  final String input;
  final String encoding;
  final bool continuing;

  DataSet(this.input, { encoding: null, continuing: false })
    : this.encoding = encoding,
      this.continuing = continuing;

  String get description
    => input == null
      ? 'the empty string'
      : '"$input"';
}

void runTests() {
  DigestAlgorithm sha1 = md.sha1;
  DigestAlgorithm sha256 = md.sha256;
  DigestAlgorithm sha384 = md.sha384;
  DigestAlgorithm sha512 = md.sha512;

  DataSet empty = new DataSet(null);
  DataSet abc = new DataSet('abc');
  DataSet bigabc = new DataSet('abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu');
  DataSet fox = new DataSet('The quick brown fox jumps over the lazy dog');
  DataSet utf8 = new DataSet('c\'\u00e8', encoding: 'utf8');
  DataSet smallcont = new DataSet(
    'THIS IS A MESSAGE',
    continuing: true
  );
  DataSet cont = new DataSet(
    'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq',
    continuing: true
  );

  Map<DigestAlgorithm, Map<DataSet, String>> cases = {};

  cases[sha1] = {};
  cases[sha1][empty] = 'da39a3ee5e6b4b0d3255bfef95601890afd80709';
  cases[sha1][abc] = 'a9993e364706816aba3e25717850c26c9cd0d89d';
  cases[sha1][fox] = '2fd4e1c67a2d28fced849ee1bb76e7391b93eb12';
  cases[sha1][utf8] = '98c9a3f804daa73b68a5660d032499a447350c0d';
  cases[sha1][smallcont] = '5f24f4d6499fd2d44df6c6e94be8b14a796c071d';

  cases[sha256] = {};
  cases[sha256][empty] = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';
  cases[sha256][abc] = 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad';
  cases[sha256][fox] = 'd7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592';
  cases[sha256][utf8] = '1aa15c717afffd312acce2217ce1c2e5dabca53c92165999132ec9ca5decdaca';
  cases[sha256][cont] = '248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1';

  cases[sha384] = {};
  cases[sha384][empty] = '38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b';
  cases[sha384][abc] = 'cb00753f45a35e8bb5a03d699ac65007272c32ab0eded1631a8b605a43ff5bed8086072ba1e7cc2358baeca134c825a7';
  cases[sha384][bigabc] = '09330c33f71147e83d192fc782cd1b4753111b173b3b05d22fa08086e3b0f712fcc7c71a557e2db966c3e9fa91746039';
  cases[sha384][fox] = 'ca737f1014a48f4c0b6dd43cb177b0afd9e5169367544c494011e3317dbf9a509cb1e5dc1e85a941bbee3d7f2afbc9b1';
  cases[sha384][utf8] = '382ec8a92d50abf57f7d0f934ff3969d6d354d30c96f1616678a920677867aba49521d2d535c0f285a3c2961c2034ea3';
  cases[sha384][cont] = '3391fdddfc8dc7393707a65b1b4709397cf8b1d162af05abfe8f450de5f36bc6b0455a8520bc4e6f5fe95b1fe3c8452b';

  cases[sha512] = {};
  cases[sha512][empty] = 'cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e';
  cases[sha512][abc] = 'ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f';
  cases[sha512][bigabc] = '8e959b75dae313da8cf4f72814fc143f8f7779c6eb9f7fa17299aeadb6889018501d289e4900f7e4331b99dec4b5433ac7d329eeb6dd26545e96e55b874be909';
  cases[sha512][fox] = '07e547d9586f6a73f73fbac0435ed76951218fb7d0c8d788a309d785436bbb642e93a252a954f23912547d1e8a3b5ed6e1bfd7097821233fa0538f3db854fee6';
  cases[sha512][utf8] = '9afdc0390dd91e81c63f858d1c6fcd9f949f3fc89dbdaed9e4211505bad63d8e8787797e2e9ea651285eb6954e51c4f0299837c3108cb40f1420bca1d237355c';
  cases[sha512][cont] = '204a8fc6dda82f0a0ced7beb8e08a41657c16ef468b228a8279be331a703c33596fd15c13b1b07f9aa1d3bea57789ca031ad85c7a71dd70354ec631238ca3445';

  group('Message digest', () {
    Digest digest;

    cases.forEach((algo, sets) {
      group(algo.create().algorithm, () {
        setUp(() {
          digest = algo.create();
        });

        sets.forEach((dataset, expected) {
          test('digests ${dataset.description}', () {
            if (dataset.continuing) {
              digest.start();
            }

            if (dataset.input != null) {
              if (dataset.encoding != null) {
                digest.update(dataset.input, encoding: dataset.encoding);
              }
              else {
                digest.update(dataset.input);
              }
            }

            expect(digest.digest().toHex(), equals(expected));

            if (dataset.continuing) {
              // Assert twice to check continuing digest.
              expect(digest.digest().toHex(), equals(expected));
            }
          });
        });
      });
    });
  });
}
