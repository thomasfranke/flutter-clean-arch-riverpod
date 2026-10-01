# `arch` — the project CLI

Every task this repository has is one command. `dart run tool/arch.dart` with
no arguments opens a navigable menu; with a subcommand it runs the same code
path non-interactively. `make <target>` is a one-line face over the same
thing, kept because `make verify` is shorter to type and because the target
names predate the CLI.

```
dart run tool/arch.dart            # the menu
dart run tool/arch.dart verify     # everything CI runs
make verify                        # the same thing
```

## Two faces, one engine

The menu never does work the subcommand cannot do. Before it runs anything it
prints the invocation it is about to make:

```
ARCH — Clean Arch + Riverpod

Tests › Unit

  → dart run tool/arch.dart test unit data
```

That line is the contract between the two faces. A menu row whose value is
`test unit` *is* `arch test unit`, so the two cannot drift apart without the
divergence showing on screen — and it doubles as a way to learn the command
line by using the menu.

The menu needs a terminal and knows when it does not have one.
[`tool/src/tty.dart`](../../tool/src/tty.dart) answers that question once, for
everything: stdout redirected to a pipe has no cursor to move, and CI has a
terminal-shaped stream with nothing behind it. In both cases the dashboards
print appended lines instead of repainting, which is why the GitHub workflow
calls the same commands a person calls rather than inlining its own loops.

## What it can do

`--help` lists everything. The groups the root screen uses:

| Group | Commands |
|---|---|
| — | `build`, `run` |
| Setup | `doctor`, `fvm`, `setup`, `updates` |
| Dev Tools | `clean`, `codegen`, `l10n`, `verify` |
| Tests | `test`, `coverage`, `e2e` |

`analyze`, `format`, `codegen-gate` and `coverage-gate` are hidden from the
menu and still commands: each is a step of `verify`, and a row for it would
offer one step of a sequence nobody runs one at a time. Scripts and the
Makefile call them by name.

## Layout

```
tool/arch.dart                 the entry point: the menu, and the dispatch
tool/analysis_options.yaml     the CLI's own rules, and why they differ
tool/src/repo.dart             the repository root, found by marker
tool/src/tty.dart              draw, or log?
tool/src/theme/                the visual language — layout, palettes, glyphs
tool/src/cli/terminal.dart     raw mode, keys, and putting the terminal back
tool/src/cli/menu.dart         a screen: rows, sections, footer, redraw
tool/src/cli/dashboard.dart    a block of rows repainted while work runs
tool/src/commands/             one file per command, plus the two runners
integration_test/support/      the e2e harness: steps, frames, the robot
test_driver/                   the host half of an e2e run: where frames land
```

Two files under `commands/` are executables rather than libraries —
`run_tests.dart` and `run_changed_tests.dart` — because they are long-running
and draw their own output. The command that calls them (`tests.dart`) does
nothing but build an argument list.

`tool/` imports nothing but `dart:*`. That is not minimalism: this is the tool
that resolves the package, pins the SDK and reports what is missing, and it
cannot require any of that to have happened before it runs.

## The test dashboard

One `flutter test` invocation, many rows.

```
• Running tests — 5/9 groups, 34/60 files:
  ✓  architecture   ████████████████████ 1/1  files  •  6/6   tests  ⏱ 1s
  ✓  core           ████████████████████ 3/3  files  •  18/18 tests  ⏱ 2s
  ▸  data           ███████████░░░░░░░░░ 9/16 files  •  +71 ✗0  •  ⏱ 6s
  ·  presentation   ░░░░░░░░░░░░░░░░░░░░ 4 files
```

This is the one place the CLI departs from the shape it was ported from,
because the repository underneath it is a different shape. A workspace that
splits its layers into packages gets a row per package for free: each package
is its own `flutter test` run. Here there is one package, so splitting the
suite to get a row per run would pay the compile cost over and over for
nothing.

So the rows are cut out of the *paths* instead. `test/unit/<layer>` is that
layer's row, `test/widget` is one row, `test/integrity/architecture_test.dart`
is another — the grouping the folders already declare, read back rather than
maintained twice. The suite compiles once, the JSON reporter says which file
each event came from, and each event lands in the row its path belongs to.

The file totals are counted off disk before anything runs, because
`package:test` parses suites lazily: a denominator taken from the protocol
arrives in instalments while the bar is already moving, and a bar whose total
grows walks backwards.

## End-to-end

`arch e2e` is the one command that leaves the host. It opens the assembled app
on a device, walks it through one named flow against the live Binance API, and
records what happened.

```
arch e2e                      # the scenarios, and what each one did last
arch e2e Scales the font      # run one
arch e2e all --device=<id>    # run every one of them
arch e2e clean                # delete the recordings
```

A **scenario** is a named flow declared as a list of steps:

```dart
scenario(
  'Switches to dark mode',
  describe: 'One switch, and every screen changes …',
  group: 'Preferences',
  steps: <Step>[
    Step('open Preferences', (CryptoRobot robot) => robot.openPreferences()),
    …
  ],
);
```

The flow is data and the *how* lives in the robot, which is what lets the next
scenario reuse a wait somebody already got right. Because every step is known
before the first one runs, the CLI can draw `4/11` rather than a spinner; and
because a step has a name written for a dashboard, a failure reads *"step 6/11
— favorite the first quote"* rather than as a line number.

`integration_test/app_test.dart` is the long one, kept whole: the complete tour
the README's demo GIF is frames of. The others each prove one thing, and are
what anybody runs while working.

### The list is the screen

Each row says when that flow last passed, against which version of the app, and
how long it took, because *has anyone checked this since?* is the question the
list is read for. A flow that never ran is listed without a date rather than
hidden — the list is also how someone learns what exists. That record lives in
`.e2e-results.json`, deliberately **not** inside the recordings folder: `arch
e2e clean` throws that away by design, and nothing rebuilds a history.

### How a run is recorded

Every run is photographed from the outside: one still per step, named after the
step, beside an `.mp4` of the whole scenario and the full output of the run
under `.e2e-evidence/<scenario>/`. Runs accumulate under a timestamp, so the
evidence of a failure survives the run meant to reproduce it.

Both come from `adb`, not from the app. The device says *now* — a `shot` report
on the same protocol the progress bar reads — and holds the screen still while
the CLI answers with `adb exec-out screencap`; the video is `adb shell
screenrecord`, pulled when the scenario ends, which is why no machine here needs
ffmpeg.

It used to be the app's own job, through `binding.takeScreenshot`. That needs
`convertFlutterSurfaceToImage()` on Android, which swaps the render surface for
an image and only swaps it back at teardown: every `pump` after the first
picture waits for a frame nobody draws, so a scenario that photographed itself
and carried on hung on its next step, and the suite stopped on it reporting
nothing. The host has no such problem — it reads the window without the app
knowing.

A run with no `adb` reachable records nothing and asserts everything it asserted
before. Evidence never decides whether a scenario passed.

### Why `flutter drive`

Less than it used to be. The frames no longer travel over the driver
connection, so what is left is that
[`test_driver/integration_test.dart`](../../test_driver/integration_test.dart)
carries the run's verdict back — which `flutter test -d` does by itself. The
arrangement here is ready to lose its host half; it has not yet.

`flutter drive` has no `--plain-name`, so picking one flow out of a file that
declares three happens in the app: the CLI passes the name as
`--dart-define=E2E_ONLY`, and a scenario the CLI did not name is never declared.

### Three literals spelled twice

`tool/` imports nothing but `dart:*`, so the CLI and the app cannot share a
constant. The three things they must nevertheless agree on — the marker that
makes a step report findable in a device log, the folder the frames go in, and
the names of the defines — are checked by
[`test/integrity/e2e_catalogue_test.dart`](../../test/integrity/e2e_catalogue_test.dart),
which also reads the scenarios back and fails on a file whose flows the CLI
cannot see. A flow missing from a list is the one failure nobody notices.

### One device, one app

`arch e2e all` runs the scenarios one at a time, and not for this CLI's
convenience: the next run reinstalls the same package, which cannot happen
while the last one is still on screen. Each one also starts the app with
storage wiped, which is what makes a row's result about that row rather than
about the order the list happens to be in — the scenarios that prove something
was *remembered* relaunch the app themselves, without wiping it.

`--watch` holds the screen after each action, for a run somebody is watching
rather than one somebody will read the result of.

## Coverage

One number, measured once. `flutter test --coverage` instruments the whole of
`lib/` in the same run that checks it, so coverage costs a pass over
`coverage/lcov.info` and nothing else — there is no second run anywhere in
this CLI that exists only to measure.

Three commands read that one file:

- **`arch coverage`** renders it to HTML with `genhtml` and opens it.
- **`arch coverage-gate`** breaks it down *per layer* and fails under 95%.
  One number for the repository would hide exactly what a gate is for: a
  presentation layer at 99% and a data layer at 40% average out to something
  that passes, and nobody agreed to the average. A layer with no code yet, or
  with code nothing measured, is skipped rather than counted as zero — the
  gate is about tests falling behind code.
- **`arch coverage last`** runs only the tests the file you just edited maps
  to, then prints the coverage of *that file*, least covered first, in the
  terminal. Seconds, because the rest of the suite never runs.

Generated files are left out of the gate. A freezed `copyWith` or a Riverpod
provider shell is never called by name from a test, so counting them would
measure the generator rather than the tests.

## Narrowed runs

Both map a changed file to a test by filename and nothing else: a changed
`lib/foo.dart` runs `foo_test.dart`, wherever under `test/` it lives. No
import graph and no layer-wide fallback — touching `core` does not rerun every
layer above it.

- **`arch test diff`** takes the set from git: the branch diff, the working
  tree and the untracked files, unioned, so a file counts whether it is
  committed, staged, modified or brand new. `--base=HEAD` narrows it to
  uncommitted work.
- **`arch test last`** takes it from modification time instead. That is the
  case the diff cannot serve: a branch whose diff has grown to two hundred
  files no longer describes the last hour of work on it, and a file edited and
  then edited back is invisible to git and is exactly what someone means by
  "run what I was just working on".

Neither is a cheaper `test`. They prove the part you touched is green; the
full run is what proves the repository is.

## The gate

`arch verify` runs what CI runs, in the order that fails cheapest first:

```
format → analyze → codegen gate → tests → coverage gate
```

Stopping at the first failure is the point — a run that reports five failures
caused by one of them wastes the time it spent finding the other four.

The **codegen gate** is the one worth explaining. Generated files are
committed here, so the question it answers is whether what is checked in is
what the annotations actually produce. It deletes every `.freezed.dart`,
`.g.dart`, `.gr.dart` and `.config.dart` — and build_runner's asset graph with
them, which is the half that is easy to miss, since without it build_runner
rebuilds nothing and reports success — regenerates, runs `gen-l10n`, and then
asks `git status` whether anything moved.

## Adding a command

1. Add a `_Command` to the list in `tool/arch.dart`. It is alphabetical: the
   list is read by someone looking for a name they already have in mind.
2. Give it a `description` if it is a menu row. That text is the footer, two
   or three lines; the one-line `summary` is what `--help` prints.
3. Add a branch to `_dispatch`, and the words it accepts to `_wordsFor` — a
   command that accepts a bare word without declaring it there turns a typo
   into "none named", and none named means all of them.
4. Write the work in `tool/src/commands/`, one file per command. It returns an
   exit code; it does not call `exit`.
5. If it needs a question answered first, add a screen in `_promptFor` and a
   case to `_hasOwnScreen` — the same predicate decides whether to ask before
   a run and whether to return there after one, which is what keeps the two
   from disagreeing.
6. Add a Makefile target, one line, delegating to it.
7. `test/integrity/cli_test.dart` lists every command by name. Add it there.
