// The Result pattern, asserted against the declarations that promise it.
//
// Every operation that can fail returns an `Either<Failure, T>`, so that a
// caller cannot read the value without having said what it does about the
// failure. What makes that a rule rather than a habit is the side the failure
// is on: a domain `Failure` above the repository, an infrastructure one
// below it, and never the wrong one — the boundary the whole arrangement
// exists to draw.
//
// Read off the declaration line, which is where a return type is written and
// the one place it cannot be built at runtime.

import 'package:flutter_test/flutter_test.dart';

import 'support/lib_sources.dart';

/// The folder holding the contracts the domain offers upwards.
const String contractFolder = 'lib/domain/repositories';

/// The folder holding the classes that resolve data from one source.
const String datasourceFolder = 'lib/data/data_sources';

/// What a contract above the repository returns on the left.
const String domainFailure = 'Failure';

/// What a datasource returns on the left, depending on what it talks to.
const List<String> infrastructureFailures = <String>[
  'HttpClientFailure',
  'StorageFailure',
];

/// The suffix that marks a class as a use case.
const String useCaseSuffix = 'UseCase';

/// The method a use case is invoked through.
const String invocation = 'call';

void main() {
  group('the Result pattern', () {
    test('every method on a domain contract returns Either<Failure, _>', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (source.folder != contractFolder) {
          continue;
        }
        for (final _Method method in _methodsIn(source)) {
          if (method.returns('Either<$domainFailure,')) {
            continue;
          }
          breaks.add('${source.path}: ${method.description}');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'A domain contract promises a failure as a value. A method that '
            'returns anything else either cannot fail — and should say so by '
            'returning the value — or fails by some other means.',
      );
    });

    test('every datasource method returns an infrastructure failure', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (source.folder != datasourceFolder || source.isWiring) {
          continue;
        }
        for (final _Method method in _methodsIn(source)) {
          if (infrastructureFailures.any(
            (final String failure) => method.returns('Either<$failure,'),
          )) {
            continue;
          }
          breaks.add('${source.path}: ${method.description}');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'A datasource hands up the failure it was given — '
            '${infrastructureFailures.join(' or ')} — and the repository '
            'translates it. A datasource returning a domain Failure has '
            'translated too early; one returning no Either has swallowed '
            'the failure.',
      );
    });

    test('every use case is invoked through call, and it returns Either', () {
      final List<String> breaks = <String>[];

      for (final Source source in libSources()) {
        if (source.layer != 'application' || source.isWiring) {
          continue;
        }
        final String? declared = source.declaredType;
        if (declared == null || !declared.endsWith(useCaseSuffix)) {
          continue;
        }

        final List<_Method> invocations = <_Method>[
          for (final _Method method in _methodsIn(source))
            if (method.name == invocation) method,
        ];

        if (invocations.isEmpty) {
          breaks.add('${source.path}: $declared declares no $invocation');
          continue;
        }
        for (final _Method method in invocations) {
          if (method.returns('Either<$domainFailure,')) {
            continue;
          }
          breaks.add('${source.path}: ${method.description}');
        }
      }

      expect(
        breaks,
        isEmpty,
        reason:
            'A use case is one operation, invoked as a function, answering '
            'with an Either. The uniform shape is what lets a notifier read '
            'any of them the same way.',
      );
    });
  });
}

/// One method declaration, as its own line says it.
class _Method {
  _Method(this.returnType, this.name);

  /// Everything written before the method's name.
  final String returnType;

  /// The method's name.
  final String name;

  /// Whether the declared return type contains [type], awaited or not.
  ///
  /// Containment rather than equality: an awaited
  /// `Either<Failure, List<KlineEntity>>` and a bare `Either<Failure, Unit>`
  /// both satisfy the rule, and the right-hand
  /// side of the Either is the method's business, not this rule's.
  bool returns(final String type) => returnType.contains(type);

  /// How the method reads back in a failure message.
  String get description => '$returnType $name(...)';
}

/// The methods [source] declares, read off their own lines.
///
/// A member with a parameter list and a lower-case name: that excludes the
/// fields, which have no list, and the constructors, whose name is the
/// class's and therefore capitalised.
List<_Method> _methodsIn(final Source source) => <_Method>[
  for (final String line in source.codeLines)
    if (_declaration.firstMatch(line) case final RegExpMatch match)
      _Method(match.group(1)!.trim(), match.group(2)!),
];

final RegExp _declaration = RegExp(r'^  ([A-Z][\w<>, ?]*?)\s+([a-z_]\w*)\s*\(');
