// `dynamic` lives at the seam JSON comes in through, and nowhere else.
//
// A `dynamic` is the type system switched off for one value: every call on it
// resolves at runtime, every typo in a field name compiles, and the error
// arrives as a crash on a phone instead of a squiggle in the editor.
//
// It is unavoidable exactly once — a decoded JSON body is a `Map<String,
// dynamic>` because that is what the network said — and the folders below are
// where that arrives and is turned into something typed. Above them a
// `dynamic` is not the network's fault; it is a type somebody did not write.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// Where a decoded body arrives, and is read for the last time untyped.
///
/// `data_objects/` holds the DTOs that parse it, `data_sources/` the calls
/// that receive it, and `http_client/` the client that decoded it. The DTO is
/// the last place `dynamic` appears and the first place a field has a type.
const List<String> decodingFolders = <String>[
  'lib/data/data_objects',
  'lib/data/data_sources',
  'lib/infrastructure/http_client',
];

void main() {
  group('the type system stays on', () {
    test('nothing outside the decoding seam names dynamic', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (decodingFolders.any(source.path.startsWith)) {
          continue;
        }
        for (final MapEntry<int, String> line
            in source.codeLines.asMap().entries) {
          if (!_dynamic.hasMatch(line.value)) {
            continue;
          }
          breaks.add('${source.path}:${line.key + 1}: ${line.value.trim()}');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Give the value the type it actually has. If it genuinely has '
            'none until runtime, it has come from outside the app and belongs '
            'behind a DTO in data/data_objects, which is where the network '
            'stops being the network.',
      );
    });

    test('the seam is still where decoding happens', () {
      // The folders are named, so a decoding folder that moved would leave
      // this rule guarding an empty path and passing for the wrong reason.
      for (final String folder in decodingFolders) {
        expect(
          libSources().any(
            (final Source source) => source.path.startsWith(folder),
          ),
          isTrue,
          reason: '$folder is named as a decoding folder but holds nothing',
        );
      }
    });
  });
}

/// `dynamic` as a type, not as a word in an identifier.
final RegExp _dynamic = RegExp(r'\bdynamic\b');
