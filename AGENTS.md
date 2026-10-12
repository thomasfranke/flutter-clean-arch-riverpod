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
[`test/integrity/architecture_test.dart`](test/integrity/architecture_test.dart)
exists: nothing but that test stops `domain/` importing `presentation/`.

## Source of truth

- [`README.md`](README.md) — what each layer is for, the folder structure, the
  dependencies and why each one is there. **Consult before suggesting a
  dependency or moving code between layers.**
- [`docs/technical/cli.md`](docs/technical/cli.md) — `arch`, the CLI every
  task in this repository runs through, and how its pieces fit.
- [`test/integrity/architecture_test.dart`](test/integrity/architecture_test.dart)
  — the layer graph, as code. When the README and this file disagree, this one
  is what actually holds.

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
3. **`domain`, `application` and `infrastructure` stay Flutter-free.** No
   `package:flutter`, no `flutter_riverpod`, no `auto_route`, no `fl_chart`.
   That is what keeps their tests running without a widget binding.
4. **Dio and SharedPreferences are reached through contracts.**
   `HttpClientInterface` and `StorageInterface`. Nothing outside
   `infrastructure/` imports either package, and
   `wrappedPackageExceptions` in the architecture test is empty. **Keep it
   empty**; an entry needs its reason written beside it.
5. **A domain `Failure` is minted in `repositories_impl/`, never in a
   datasource.** A datasource resolves data: it returns the
   `HttpClientFailure` or `StorageFailure` it was handed, untouched. The
   repository implementation calls `toDomainFailure()` on the way out, because
   it is the class that implements a `domain` contract. Translating earlier
   flattens distinctions a repository composing two sources would need —
   [`README.md`](README.md) has the reasoning. Unlike rules 2–4, no test
   fails over this one yet.
6. **Generated files are committed.** `.freezed.dart`, `.g.dart`, `.gr.dart`,
   `.config.dart` and `lib/core/l10n/generated/`. After changing an annotated
   source or an ARB file, run `make runner` and commit the result — the
   codegen gate fails the build otherwise.
7. **Never hand-edit a generated file.**
8. **`tool/` imports nothing but `dart:*`.** A tool that resolves the package,
   pins the SDK and reports what is missing cannot require any of that to have
   happened before it runs. It has its own
   [`tool/analysis_options.yaml`](tool/analysis_options.yaml).
9. **An end-to-end flow is a `scenario`, never a bare `testWidgets`.**
   `arch e2e` reads the scenarios out of their own source, so a flow declared
   any other way runs but is invisible to the list, to the recording and to the
   history. `test/integrity/e2e_catalogue_test.dart` is what refuses it. The
   *how* belongs in `integration_test/support/robot.dart`, not in the steps.
10. **Do not commit unless asked.** Draft the message; leave the commit.

## The commands

`make help` lists them all. `dart run tool/cli.dart` with no arguments opens
a navigable menu; with a subcommand it runs the same code path
non-interactively, which is what CI and agents use. The ones worth knowing:

| Command | What it does |
|---|---|
| `arch verify` | Everything CI runs, in order, stopping at the first failure |
| `arch test` | The whole suite, with coverage, as a live dashboard |
| `arch test unit data` | One kind, one layer |
| `arch test arch` | The layer graph alone — seconds |
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
test/integrity/        about the repository itself: the graph, the CLI, the e2e catalogue
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
