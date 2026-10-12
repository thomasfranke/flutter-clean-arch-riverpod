// A file and the class in it agree on whether there is one of something.
//
// `class_names` checks the suffix and stops there, so a file called
// `crypto_quotes_datasource.dart` holding a `CryptoQuotesDatasource` passes
// it: the suffix is right and the number is not. Then the repository that
// implements it is `CryptoQuotesRepositoryImpl`, plural, satisfying a
// contract named in the singular — and reading that chain, nobody can tell
// whether one quote or many is the subject.
//
// Only the number is checked. A word the class spells differently for any
// other reason — `GetKlinesUseCase` for `get_klines_usecase`, where the file
// writes `usecase` as one word — is not this rule's business.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

void main() {
  group('a file and its class agree on number', () {
    test('no word differs between them by a trailing s alone', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        final String? declared = source.declaredType;
        if (declared == null) {
          continue;
        }

        final List<String> inFile = source.name.split('_');
        final List<String> inClass = _words(declared);
        final int shared = inFile.length < inClass.length
            ? inFile.length
            : inClass.length;

        for (int at = 0; at < shared; at++) {
          if (!_differsOnlyInNumber(inFile[at], inClass[at])) {
            continue;
          }
          breaks.add(
            '${source.path}: the file says "${inFile[at]}" where $declared '
            'says "${inClass[at]}"',
          );
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'One of the two is wrong, and which one is a decision about what '
            'the file is for: a datasource that fetches many quotes is '
            'plural, and the entity it builds is singular. Pick the one the '
            'contents read as, and spell it that way in both places.',
      );
    });
  });
}

/// [name] split into the words it is written from.
///
/// `CryptoQuoteDTO` is three words, not two and a shout: a run of capitals is
/// one word, so an acronym survives the split whole and compares against the
/// file's own spelling of it.
List<String> _words(final String name) => <String>[
  for (final RegExpMatch match in _word.allMatches(name))
    match.group(0)!.toLowerCase(),
];

/// Whether [fromFile] and [fromClass] are the same word in different number.
bool _differsOnlyInNumber(final String fromFile, final String fromClass) {
  if (fromFile == fromClass) {
    return false;
  }
  return '${fromFile}s' == fromClass || fromFile == '${fromClass}s';
}

final RegExp _word = RegExp(r'[A-Z]+(?![a-z])|[A-Z][a-z0-9]*|[a-z0-9]+');
