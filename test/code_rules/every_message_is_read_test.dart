// Every message in the ARB files is shown somewhere.
//
// A key nobody reads is three translations — English, Portuguese, Spanish —
// written, reviewed and carried for a sentence that never reaches a screen.
// It also makes the file misleading: the ARB is the closest thing this app
// has to a list of everything it says, and a dead key is a sentence it
// claims to say and does not.
//
// Read as `.key` against the source rather than through the generated
// getters, because the generated class has a getter for every key by
// definition and would agree with itself.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// The ARB the others are translations of.
const String templateArb = 'lib/core/l10n/app_en.arb';

/// Where a message may be read: the screens, the composition root, and the
/// end-to-end harness, which reads them to recognise what it is looking at.
const List<String> readingPlaces = <String>[
  'lib/presentation',
  'lib/main.dart',
  'integration_test',
];

void main() {
  group('every message reaches a screen', () {
    test('the template is there and holds messages', () {
      expect(File(templateArb).existsSync(), isTrue);
      expect(_messages(), isNotEmpty, reason: '$templateArb holds no message');
    });

    test('every key is read somewhere', () {
      final String everywhere = _readingSource();

      final List<String> unread = <String>[
        for (final String key in _messages())
          if (!RegExp('\\.$key\\b').hasMatch(everywhere)) key,
      ];

      expect(
        unread,
        isEmpty,
        reason:
            'Show it or delete it. A key carried in three languages for a '
            'sentence no screen reads makes the ARB a list of what this app '
            'claims to say rather than what it says.',
      );
    });
  });
}

/// The message keys in the template, metadata left out.
List<String> _messages() {
  final Object? decoded = jsonDecode(File(templateArb).readAsStringSync());
  if (decoded is! Map<String, dynamic>) {
    return const <String>[];
  }
  return <String>[
    for (final String key in decoded.keys)
      if (!key.startsWith('@')) key,
  ];
}

/// Every place a message could be read from, as one body of text.
String _readingSource() {
  final StringBuffer buffer = StringBuffer();
  for (final String place in readingPlaces) {
    if (File(place).existsSync()) {
      buffer.writeln(File(place).readAsStringSync());
      continue;
    }
    for (final Source source in sourcesUnder(place)) {
      buffer.writeln(source.codeLines.join('\n'));
    }
  }
  return buffer.toString();
}
