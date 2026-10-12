// Nothing a person reads is written in the source.
//
// Every sentence the app shows comes from `AppLocalizations`, which reads it
// out of the ARB files — so adding a language is editing three files in
// `core/l10n/`, never hunting through the screens. A literal in a widget is
// a sentence that exists in one language and cannot be found by searching
// the place all the others are.
//
// Read as literals rather than as widget arguments on purpose. Looking for
// `Text('…')` finds the obvious ones and misses `tooltip:`, `semanticLabel:`
// and the next widget somebody uses; looking for every literal and naming
// the ones that are not sentences cannot miss anything — the list of what is
// not a sentence is short, and it is the interesting list anyway.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// Where the app's own words would be written, if they were written.
const List<String> speakingLayers = <String>['presentation'];

/// Literals that are not sentences, and what each one is instead.
///
/// The list the rule is really about. Every entry is a string that looks like
/// text and is not: an identifier the API reads, a pattern a formatter reads,
/// a name that is the same in every language. Anything not here is a sentence
/// and belongs in the ARB files.
const Map<String, String> notSentences = <String, String>{
  '15m': 'a Binance kline interval, sent to the API',
  '1h': 'a Binance kline interval, sent to the API',
  '4h': 'a Binance kline interval, sent to the API',
  '1d': 'a Binance kline interval, sent to the API',
  'HH:mm': 'a DateFormat pattern, not words',
  'dd/MM HH:mm': 'a DateFormat pattern, not words',
  'pt': 'a locale code, which is the same in every language',
  'en': 'a locale code, which is the same in every language',
  'es': 'a locale code, which is the same in every language',
  // A language is listed in its own language — that is the one string a
  // translation would make worse, because the person who needs it is by
  // definition not reading the current one.
  'Português': 'a language, named in itself',
  'English': 'a language, named in itself',
  'Español': 'a language, named in itself',
  'A': 'the glyph the font-size slider is sampled with, not a word',
};

void main() {
  group('every sentence comes from the ARB files', () {
    test('no literal in the speaking layers is a sentence', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (!speakingLayers.contains(source.layer)) {
          continue;
        }
        for (final String literal in source.stringLiterals) {
          final String bare = _withoutInterpolation(literal);
          if (!_hasLetter(bare) || notSentences.containsKey(literal)) {
            continue;
          }
          breaks.add('${source.path}: "$literal"');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'Put each of these in the three ARB files under core/l10n, read '
            'it back through AppLocalizations, and run `arch codegen`. If it '
            'is not a sentence after all, add it to notSentences with what '
            'it is instead.',
      );
    });

    test('every literal named as not a sentence is still written', () {
      final Set<String> written = <String>{
        for (final Source source in libSources())
          if (speakingLayers.contains(source.layer)) ...source.stringLiterals,
      };

      final List<String> gone = <String>[
        for (final String literal in notSentences.keys)
          if (!written.contains(literal)) literal,
      ];

      expect(
        gone,
        isEmpty,
        reason:
            'These are listed as not being sentences but no longer appear in '
            '${speakingLayers.join(', ')}. Remove them — a list of '
            'exceptions that outlives the exceptions stops being read.',
      );
    });
  });
}

/// [literal] with every `${…}`, `$name` and escape sequence taken out.
///
/// What is interpolated is a value, not a word: `'$sign${pct}%'` reads as
/// text to a regular expression and says nothing in any language. An escape
/// goes for a narrower reason — the `n` of a `\n` is a letter to a pattern
/// and a newline to everyone else.
String _withoutInterpolation(final String literal) => literal
    .replaceAll(RegExp(r'\$\{[^}]*\}'), '')
    .replaceAll(RegExp(r'\$[A-Za-z_]\w*'), '')
    .replaceAll(RegExp(r'\\.'), '');

bool _hasLetter(final String text) => RegExp('[A-Za-zÀ-ÿ]').hasMatch(text);
