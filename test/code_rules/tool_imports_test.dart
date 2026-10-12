// `tool/` imports nothing but `dart:*` and its own files.
//
// The CLI resolves the package, pins the SDK and reports what is missing. It
// cannot require any of that to have happened before it runs, which rules out
// every `package:` import — including this repository's own, which would
// resolve today and make the claim a lie tomorrow.
//
// It is the only rule here that reads something other than `lib/`, and the
// reason it is a rule at all is that nothing else can catch it: a package
// import added to `tool/` analyses clean and works on a developer's machine.
// It fails on a checkout where `pub get` has not run — which is the one
// machine the CLI exists to serve.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// Where the CLI lives.
const String toolDirectory = 'tool';

/// The one scheme `tool/` may name.
const String allowedScheme = 'dart:';

void main() {
  group('the CLI depends on nothing', () {
    test('no file under tool imports a package', () {
      final List<String> breaks = <String>[];

      for (final Source source in sourcesUnder(toolDirectory)) {
        for (final String import in source.allImports) {
          if (import.startsWith(allowedScheme) || !import.contains(':')) {
            continue;
          }
          breaks.add('${source.path} imports $import');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'The CLI is what tells you the toolchain is missing, so it has '
            'to run before the toolchain is there. A package import makes it '
            'depend on the thing it reports on.',
      );
    });

    test('it has its own analyzer config, which is why it may differ', () {
      expect(
        File('$toolDirectory/analysis_options.yaml').existsSync(),
        isTrue,
        reason:
            'tool/ leans on inference and relative imports where lib/ forbids '
            'both. Without its own config the root rules apply to it, and '
            'the gate either fails or gets turned off.',
      );
    });
  });
}
