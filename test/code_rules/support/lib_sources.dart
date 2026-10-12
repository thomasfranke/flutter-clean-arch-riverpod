// Reading `lib/` as text, for every rule that asks a question about it.
//
// Every rule beside this folder begins the same way: walk the hand-written
// source under `lib/` and look at what it declares. The walking, the import
// extraction and the vocabulary the rules share live here, so a rule file
// holds the rule and nothing else.
//
// Text rather than the analyzer, for the same reason the layer graph has
// always been read this way: every question asked here is about what a file
// says, and a declaration is written on a line.
library;

import 'dart:io';

// --------------------------------------------------------------------------
// The vocabulary
//
// The words every rule shares. Here rather than in each file so that
// `kernel`, `wiringSuffix` and the rest mean one thing across twenty-one
// rules instead of one thing each — and so that changing what a word
// covers is one edit with twenty-one readers, which is the point.
// --------------------------------------------------------------------------

/// The layers, in dependency order.
const List<String> layers = <String>[
  'core',
  'domain',
  'application',
  'data',
  'infrastructure',
  'presentation',
];

/// The package's own import prefix, which is how a file names another layer.
const String selfPackage = 'package:flutter_clean_arch_riverpod/';

/// The suffix that marks a file as composition wiring rather than logic.
///
/// A `*_di.dart` holds Riverpod providers and nothing else: it names an
/// implementation so something else does not have to.
const String wiringSuffix = '_di.dart';

/// Files any layer may import, whatever the graph allows.
///
/// `Either` is vocabulary at the level of the language — what `Future` is to
/// async code — so importing it says nothing about which layer a file knows.
/// It sits under `core/` for want of a better home, but counting it as `core`
/// would hand `infrastructure` the domain's `Failure` along with it.
const Set<String> kernel = <String>{'core/either/either.dart'};

/// The packages `infrastructure` exists to wrap.
///
/// Each one is reached through a contract — `HttpClientInterface`,
/// `StorageInterface` — so that swapping Dio for something else is an edit
/// inside one folder rather than across the repository. Two rules read this
/// list: one checks nobody outside `infrastructure/` names a package in it,
/// the other that the wrapper around each one is complete.
const List<String> wrappedPackages = <String>[
  'package:dio/',
  'package:shared_preferences/',
];

/// Folders a generator owns whole, which `arch codegen hard` empties.
///
/// `gen-l10n` writes files with ordinary names rather than a suffix, so the
/// only thing that marks them as generated is where they are.
const List<String> generatedFolders = <String>['lib/core/l10n/generated/'];

/// The suffixes a generator owns. The same four `arch codegen hard` deletes.
const List<String> generated = <String>[
  '.freezed.dart',
  '.g.dart',
  '.gr.dart',
  '.config.dart',
];

/// The composition root, which exists to know every layer at once.
const String compositionRoot = 'lib/main.dart';

// --------------------------------------------------------------------------
// What a file is
//
// A rule asks questions of a file: which layer it is in, what it imports,
// what it declares, what it says. [Source] answers all of them off the
// text, lazily, so a rule that only reads imports never pays for the
// rest.
// --------------------------------------------------------------------------

/// One hand-written source file under `lib/`.
class Source {
  /// Creates a [Source] at [path] whose text is [lines].
  Source(this.path, this.lines);

  /// Reads [file], taking its path as repository-relative.
  factory Source.read(final File file) =>
      Source(file.path.replaceAll(r'\', '/'), file.readAsLinesSync());

  /// Repository-relative, with forward slashes: `lib/domain/entities/x.dart`.
  final String path;

  /// Every line of the file, in the order they appear.
  final List<String> lines;

  /// Every `package:` URI the file imports, in the order they appear.
  ///
  /// Matched on the line rather than parsed, because an import is the one
  /// Dart construct that has to be on its own line and cannot be built at
  /// runtime.
  late final List<String> imports = <String>[
    for (final String line in lines)
      if (_import.firstMatch(line) case final RegExpMatch match)
        match.group(1)!,
  ];

  /// Every URI the file imports, `dart:` and relative ones included.
  ///
  /// [imports] answers "which packages", which is what the layer graph asks.
  /// This answers "what does this file reach for at all", which is what a
  /// rule about a folder that may reach for nothing has to ask.
  late final List<String> allImports = <String>[
    for (final String line in lines)
      if (_anyImport.firstMatch(line) case final RegExpMatch match)
        match.group(1)!,
  ];

  /// The lines with their comments taken off, so a rule reading the code
  /// does not match a word in the prose above it.
  ///
  /// `//` inside a URL is left alone — `:` before it is what tells the two
  /// apart — and a line that was only a comment becomes empty rather than
  /// disappearing, so a line number still means what it says.
  late final List<String> codeLines = <String>[
    for (final String line in lines) line.replaceAll(_comment, '').trimRight(),
  ];

  /// Every string literal the file's code holds, as written.
  ///
  /// Directives are left out — the path in an `import` is a string and never
  /// a message — and so are comments, which [codeLines] has already taken
  /// off. Triple-quoted strings are read whole, across the lines they span.
  late final List<String> stringLiterals = <String>[
    for (final RegExpMatch match in literalPattern.allMatches(
      _codeWithoutDirectives,
    ))
      match.group(1) ?? match.group(2) ?? match.group(3) ?? match.group(4)!,
  ];

  late final String _codeWithoutDirectives = <String>[
    for (final String line in codeLines)
      if (!directivePattern.hasMatch(line)) line,
  ].join('\n');

  /// Which layer the file belongs to, or an empty string for [compositionRoot].
  String get layer {
    final List<String> parts = path.split('/');
    return parts.length > 2 && layers.contains(parts[1]) ? parts[1] : '';
  }

  /// The file's name, without the `.dart`: `crypto_quote_entity`.
  String get name => path.split('/').last.replaceAll('.dart', '');

  /// The folder the file sits in: `lib/domain/entities`.
  String get folder => (path.split('/')..removeLast()).join('/');

  /// Whether this file is composition wiring.
  bool get isWiring => path.endsWith(wiringSuffix);

  /// The layers of this package that the file imports, each once.
  Set<String> get importedLayers => <String>{
    for (final String import in imports)
      if (import.startsWith(selfPackage) &&
          !kernel.contains(import.substring(selfPackage.length)))
        import.substring(selfPackage.length).split('/').first,
  }..removeWhere((final String imported) => !layers.contains(imported));

  /// Every public class, enum or mixin the file declares, with the line that
  /// declares it — so a rule can read what a type is as well as its name.
  ///
  /// Private ones are left out. A screen declares the widgets it is built
  /// from in the same file and they are nobody else's business, which is what
  /// the underscore says.
  late final List<Declaration> publicDeclarations = <Declaration>[
    for (final String line in codeLines)
      if (_declaration.firstMatch(line) case final RegExpMatch match)
        if (!match.group(2)!.startsWith('_'))
          Declaration(match.group(2)!, line.trim()),
  ];

  /// The first class, enum or mixin the file declares publicly, if any.
  ///
  /// The first rather than all of them: a screen declares the private widgets
  /// it is built from in the same file, and those are not what the file is
  /// named after.
  ///
  /// An `extension` is not one. A file's suffix names a kind of class — a
  /// DTO, a use case, a repository implementation — and a file that declares
  /// only extensions or top-level functions has no such kind to name. It is a
  /// helper, and the rules read it as one.
  String? get declaredType =>
      publicDeclarations.isEmpty ? null : publicDeclarations.first.name;
}

/// One public type, and the line that declares it.
class Declaration {
  /// Creates a [Declaration] of [name], declared by [line].
  const Declaration(this.name, this.line);

  /// The type's name.
  final String name;

  /// The declaration line, trimmed — `sealed class Either<L, R> {`.
  final String line;

  /// Whether this type is sealed, and so stands for its own variants.
  bool get isSealed => line.startsWith('sealed ');

  /// Whether this type is declared as a variant of [root] — it extends or
  /// implements it.
  bool isVariantOf(final String root) =>
      RegExp('(extends|implements)\\s+$root\\b').hasMatch(line);
}

// --------------------------------------------------------------------------
// Walking the tree
//
// Two ways in, and the difference is the subject: most rules are about
// `lib/`, and the ones about the CLI or the tests name their own folder.
// --------------------------------------------------------------------------

/// Every hand-written source file under `lib/`, [compositionRoot] included.
///
/// Generated files are left out: nobody chose their imports or their names, so
/// a rule broken there is a bug to report to the generator's configuration
/// rather than to an author.
List<Source> libSources() => <Source>[
  for (final FileSystemEntity entity in Directory(
    'lib',
  ).listSync(recursive: true))
    if (entity is File && _isHandWritten(entity.path)) Source.read(entity),
];

/// Every `.dart` file under [directory], read the same way.
List<Source> sourcesUnder(final String directory) => <Source>[
  for (final FileSystemEntity entity in Directory(
    directory,
  ).listSync(recursive: true))
    if (entity is File && _isHandWritten(entity.path)) Source.read(entity),
];

/// Whether [path] is a `.dart` file somebody wrote by hand.
///
/// Generated files are left out of every rule: nobody chose their imports or
/// their names, so a rule broken there is a bug to report to the generator's
/// configuration rather than to an author.
bool _isHandWritten(final String path) {
  final String normalized = path.replaceAll(r'\', '/');
  return normalized.endsWith('.dart') &&
      !generated.any(normalized.endsWith) &&
      !generatedFolders.any(normalized.contains);
}

// --------------------------------------------------------------------------
// Reading a line
//
// The patterns the answers above are matched with. Text rather than the
// analyzer, for the reason the layer graph has always been read this way:
// every question asked here is about what a file says, and a declaration
// is written on a line.
// --------------------------------------------------------------------------

final RegExp _import = RegExp(r'''^\s*import\s+['"](package:[^'"]+)['"]''');

final RegExp _anyImport = RegExp(
  r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
);

final RegExp _comment = RegExp(r'(?<!:)//.*$');

final RegExp _declaration = RegExp(
  r'^\s*(?:abstract\s+|sealed\s+|base\s+|final\s+|interface\s+)*'
  r'(class|enum|mixin)\s+([A-Za-z_][A-Za-z0-9_]*)',
);

/// Every way Dart spells a string literal, with the contents captured.
///
/// Four alternatives in one pattern, triple-quoted first so a `'''` is not
/// read as an empty `''` followed by something else. `dotAll` is what lets
/// the triple-quoted forms span lines.
final RegExp literalPattern = RegExp(
  r"'''(.*?)'''"
  r'|"""(.*?)"""'
  r"|'([^'\n]*)'"
  r'|"([^"\n]*)"',
  dotAll: true,
);

/// An `import`, `export` or `part` line, whose string is a path.
final RegExp directivePattern = RegExp(r'^\s*(import|export|part)\s');
