# AGENTS.md

Entry point for any AI agent working in this repository (platform-agnostic by
design — Claude Code, Codex, Cursor, or anything that reads this file). Read
before any task.

## What this project is

A Flutter app that exists to demonstrate **Clean Architecture with Riverpod**,
using a small crypto-quotes client (Binance's public API) as the subject. The
feature set is deliberately modest; the architecture is the point, and so is
the fact that it is enforced rather than described.

Single Flutter package. The layers are folders under `lib/`, not published
packages — which is exactly why
[`test/code_rules/`](test/code_rules) exists: nothing but those
tests stops `domain/` importing `presentation/`.

## Source of truth

- [`README.md`](README.md) — what each layer is for, the folder structure, the
  dependencies and why each one is there. **Consult before suggesting a
  dependency or moving code between layers.**
- [`docs/technical/cli.md`](docs/technical/cli.md) — `arch`, the CLI every
  task in this repository runs through, and how its pieces fit.
- [`test/code_rules/`](test/code_rules) — the rules, as code, one
  file per rule. When the README and this file disagree with them, they are
  what actually holds. `arch test code_rules` runs the lot; `arch test code_rules <rule>`
  runs one.

## Hard rules

1. **Run everything through the CLI.** `dart run tool/cli.dart <command>`, or
   `make <target>`, which is a one-line face over the same thing. Do not
   invent a `flutter test …` invocation when a command already exists; if the
   command is missing, add it to `tool/` rather than working around it.
2. **The layer graph is not advisory.** `core ← domain ← application ← data`,
   `infrastructure` under `data`, `presentation` on top. A file may import its
   own layer and the layers listed in `allowed` in the architecture test.
   Crossing that needs either a `*_di.dart` (composition wiring, which has its
   own declared reach) or a named exception in `wiringExceptions`, with a
   reason. `core/either/either.dart` is the one file every layer may import
   (`kernel` in the test): `infrastructure` imports nothing else from `lib/`.
   Nothing under `lib/` exports, either — the graph is read off `import`
   lines, so a re-export would be a boundary crossed where nothing is
   looking. The `layer_graph` and `no_exports` rules hold it.
3. **`domain`, `application` and `infrastructure` stay Flutter-free.** No
   `package:flutter`, no `flutter_riverpod`, no `auto_route`, no `fl_chart`.
   That is what keeps their tests running without a widget binding.
4. **Dio and SharedPreferences are reached through contracts.**
   `HttpClientInterface` and `StorageInterface`. Nothing outside
   `infrastructure/` imports either package, and
   `wrappedPackageExceptions` in the architecture test is empty. **Keep it
   empty**; an entry needs its reason written beside it.
5. **A domain `Failure` is minted in `repositories_impl/`, never in a
   datasource.** A datasource resolves data from one source — the HTTP
   client or the store, never both, because choosing between them is what a
   repository is for (`one_source_per_datasource`). It returns the
   `HttpClientFailure` or `StorageFailure` it was handed, untouched. The
   repository implementation calls `toDomainFailure()` on the way out, because
   it is the class that implements a `domain` contract. Translating earlier
   flattens distinctions a repository composing two sources would need —
   [`README.md`](README.md) has the reasoning. The `failure_origin` and
   `result_pattern` rules hold it.
6. **Generated files are committed.** `.freezed.dart`, `.g.dart`, `.gr.dart`,
   `.config.dart` and `lib/core/l10n/generated/`. After changing an annotated
   source or an ARB file, run `make runner` and commit the result — the
   codegen gate fails the build otherwise.
7. **Never hand-edit a generated file.**
8. **`tool/` imports nothing but `dart:*`.** A tool that resolves the package,
   pins the SDK and reports what is missing cannot require any of that to have
   happened before it runs. It has its own
   [`tool/analysis_options.yaml`](tool/analysis_options.yaml). The `tool_imports`
   rule holds it.
9. **An end-to-end flow is a `scenario`, never a bare `testWidgets`.**
   `arch e2e` reads the scenarios out of their own source, so a flow declared
   any other way runs but is invisible to the list, to the recording and to the
   history. `test/code_rules/e2e_scenarios_test.dart` is what refuses it. The
   *how* belongs in `integration_test/support/robot.dart`, not in the steps.
10. **A file is named after what it is, and so is its class.** The folder
    asks for the suffix — `_entity`, `_usecase`, `_dto`, `_datasource`,
    `_repository_impl`, `_screen` — and the suffix asks for the class to
    carry it: `_dto` gives a `…DTO`, `_usecase` a `…UseCase`. Widgets are the
    exception, and carry no suffix at all: Flutter's own are `Drawer` and
    `ListTile`. Not cosmetics — `arch test diff` and `arch test last` map a
    changed file to its tests by filename alone, so renaming a file means
    renaming its `_test.dart` with it or the file drops out of that mapping
    silently. A file and its class also agree on number: a
    `crypto_quotes_datasource` holds a `CryptoQuotesDatasource`, not a
    `CryptoQuoteDatasource`. The `file_names`, `class_names` and
    `number_agreement` rules hold it.
11. **A file declares one public type.** A sealed type stands for its
    variants — `Left` and `Right` are what an `Either` is — and a private
    class is the file's own business. Anything else needs an entry in
    `declarationExceptions` with its reason. The `one_public_type` rule holds
    it.
12. **Nothing a person reads is written in the source.** Every sentence the
    app shows comes from the ARB files in `core/l10n/` through
    `AppLocalizations`, so adding a language is editing three files rather
    than hunting through the screens. A literal that is not a sentence — an
    API identifier, a date pattern, a language named in itself — goes in
    `notSentences` with what it is instead. And every key is read somewhere:
    one that is not is three translations carried for a sentence the app
    claims to say. The `l10n` and `every_message_is_read` rules hold it.
13. **`presentation` asks through a use case.** The layer graph stops a
    screen reaching `data/`; this stops it reaching `domain/repositories/`
    and calling the repository straight, which compiles and quietly moves the
    operation into whichever widget needed it first. A use case is the one
    name an operation has. The `usecases_only` rule holds it.
14. **A feature's Riverpod wiring is a state, a notifier and a provider.**
    One folder per feature under `presentation/providers/`, holding
    `<feature>_state.dart` and `<feature>_notifier.dart` and nothing else.
    The notifier is `@riverpod`, extends its generated base and declares the
    `part`; the state is `@freezed` and declares all four of `initial`,
    `loading`, `success`, `failure`, because every screen is a `switch` over
    them. Synchronous `Notifier`, never `AsyncNotifier`: a failure is a value
    in the state, not an exception inside an `AsyncValue`. A screen is a
    `ConsumerWidget`, so it can watch: one that takes its data as a
    constructor argument is reachable only from whoever holds the data, which
    is not something a route can do. The `riverpod_feature` and
    `screens_are_consumers` rules hold it.
15. **An entity cannot change, and does not know it is serialized.** Every
    type in `domain/entities/` is `@freezed`, nothing in `domain/` declares a
    `late` field or a setter, and no entity or contract names `fromJson`,
    `toJson` or a `json_annotation` type. A mutable entity is a handle every
    holder shares rather than a value; an entity that parses itself changes
    whenever the API does, and leaves the DTO nowhere to refuse a row it
    cannot read. The `immutable_domain` and `no_json_in_domain` rules hold
    it.
16. **Everything constructed has a provider beside it.** A use case, a
    datasource and a repository implementation each get a `*_di.dart` next to
    them. Without one the class compiles, its unit test passes against a
    mock, and no screen can reach it — a failure nothing reports. The
    `complete_wiring` rule holds it.
17. **A repository is mocked through its contract.** A test stands in for
    `…RepositoryInterface`, never for `…RepositoryImpl`, and a use case's
    test names no file in `data/` at all. Datasources are mocked as
    themselves: they are concrete by design, one per source. The
    `mocks_use_contracts` rule holds it.
18. **Every source file has a test named after it.** `arch test diff` and
    `arch test last` map a changed `lib/foo.dart` to `foo_test.dart` by
    filename and nothing else, so a file covered under another name is
    invisible to both — covered, and skipped by the fast loop. The
    `test_per_source` rule holds it, and it **fails today**: twenty-eight
    files, listed when you run it.
19. **The type system stays on, and nothing prints.** `dynamic` appears
    only where a decoded body arrives — `data/data_objects/`,
    `data/data_sources/`, `infrastructure/http_client/` — and above them it
    is a type nobody wrote rather than the network's fault. `print` appears
    nowhere: it survives the release build and writes where nobody looks,
    and `log` from `dart:developer` takes a name and can be filtered. The
    `no_dynamic` and `no_print` rules hold it. Nor is anything left for
    later: a `TODO` in a repository read as the answer is a defect the author
    knew about (`no_todo`).
20. **Every widget offers a `const` constructor.** It is what lets the parent
    hand back the same instance and skip the subtree; without one the widget
    is a new object every frame and no `const` at the call site helps. The
    analyzer checks the call sites, which is the other half. The
    `const_widgets` rule holds it.
21. **A use case is one operation, and an implementation says what it
    implements.** A `*UseCase` offers nothing but `call` — a second public
    method makes it a service, and the folder stops naming what it does. A
    `*_repository_impl.dart` declares `implements` and names its contract
    from `domain/repositories/`, because without it a method the contract
    gains is simply missing. The `one_method_per_usecase` and
    `impls_declare_contracts` rules hold it.
22. **The suite does not lie.** Every file under `test/` calls `expect` or
    `verify` — one that does not passes by reaching the end of its body.
    Nothing is turned off with `skip:`, which reports green for something
    nobody checked. Nothing hand-written carries a `coverage:ignore`, which
    raises the percentage by not being measured. The `every_test_asserts`,
    `no_skipped_tests` and `no_coverage_ignore` rules hold it.
23. **Do not commit unless asked.** Draft the message; leave the commit.

## The commands

`make help` lists them all. `dart run tool/cli.dart` with no arguments opens
a navigable menu; with a subcommand it runs the same code path
non-interactively, which is what CI and agents use. The ones worth knowing:

| Command | What it does |
|---|---|
| `arch verify` | Everything CI runs, in order, stopping at the first failure |
| `arch test` | The whole suite, with coverage, as a live dashboard |
| `arch test unit data` | One kind, one layer |
| `arch test code_rules` | Every code rule alone — seconds |
| `arch test code_rules <rule>` | One rule: `layer_graph`, `l10n`, `file_names`, … |
| `arch test diff` | Only the tests this branch's diff maps to |
| `arch test last` | Only the tests the files you just edited map to |
| `arch e2e` | The end-to-end scenarios, and what each one did last |
| `arch e2e <name>` | Run one of them on a device, recorded step by step |
| `arch coverage` | Measure, render to HTML, open it |
| `arch coverage-gate` | Fail if a layer is under the threshold (95%) |
| `arch codegen hard` | Delete every generated file and rebuild from scratch |
| `arch doctor` | Whether this machine can build the repository |

## Where things live

```
lib/                  the app, one folder per layer
test/unit/<layer>/     one class at a time, mocked — mirrors lib/ layer for layer
test/widget/           screens and widgets pumped, providers overridden
test/integration/      real flows across layers, grouped by feature
test/code_rules/       one rule per file, each reading the tree as text
test/code_rules/support/ the walker every rule reads lib/ with
test/cli/              the arch CLI, driven as a process
integration_test/      end-to-end, the real app on a device
integration_test/support/  the e2e harness: steps, frames, the robot
test_driver/           the host half of an e2e run: where the frames land
tool/                  the arch CLI — dart:* only, its own analyzer config
```

A test file is named after what it covers: `foo.dart` is covered by
`foo_test.dart`, wherever under `test/` it sits. That convention is not
cosmetic — `arch test diff` and `arch test last` map changed files to tests by
filename and nothing else.

## Skills

There are none in this repository yet. When one is added it goes in
`.ai/skills/<name>/SKILL.md`, versioned with the project, and a trigger row
belongs in this section saying when to load it.

## House style

Match what is already there. The code in `lib/` declares types explicitly
(`always_specify_types`), documents every public member, and wraps at 80
columns; `tool/` leans on inference and says why in its own analyzer config.
Comments explain *why*, not *what* — a comment restating the line below it is
noise, and one naming the alternative that was rejected is worth keeping.
