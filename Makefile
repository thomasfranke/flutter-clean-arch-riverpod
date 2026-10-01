####################################################################
### *** Makefile for Flutter: Clean Arch + Riverpod ***          ###
### A thin face over `arch`, the CLI in tool/. Run `make help`.  ###
### Every target is one line through the CLI; the logic lives    ###
### there, so it also works where `make` does not (Windows).     ###
####################################################################

# The CLI every target below delegates to. Nothing in tool/ calls back into
# `make` — that direction is the whole point.
ARCH := dart run tool/arch.dart

# The layers, in dependency order. Each may depend only on the ones before it;
# test/integrity/architecture_test.dart enforces that by reading the imports.
LAYERS := core domain application data infrastructure presentation

# Make would read `make arch test` as two goals, so the subcommand travels in
# a variable: make arch ARGS="test unit data"
ARGS ?=

.DEFAULT_GOAL := help
.PHONY: help arch setup clean fvm doctor updates l10n format analyze verify \
        flutter-test flutter-test-unit flutter-test-widget \
        flutter-test-integration flutter-test-e2e e2e-clean flutter-test-arch \
        flutter-test-cli flutter-test-diff flutter-test-last \
        coverage coverage-last coverage-diff coverage-gate \
        runner runner-hard runner-watch run build

##############################
### *** Help *** ###
##############################

help: ## List all targets
	@grep -hE '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-26s\033[0m %s\n", $$1, $$2}'

cli: ## Open the navigable CLI (ARGS="test unit" to run a command directly)
	@$(ARCH) $(ARGS)

##############################
### *** Environment *** ###
##############################

setup: ## Resolve the dependencies
	@$(ARCH) setup

clean: ## Clean build artifacts and resolve again
	@$(ARCH) clean

fvm: ## Pin the Flutter version declared in .fvmrc
	@$(ARCH) fvm

doctor: ## Check this machine has what the repository needs to build
	@$(ARCH) doctor

# Reports only. Moving the pin moves it for CI too, so it stays a decision —
# runUpdates in tool/src/commands/updates.dart.
updates: ## Compare the pinned Flutter and Dart against the latest stable
	@$(ARCH) updates

##############################
### *** Quality *** ###
##############################

format: ## Format Dart code, failing if anything changes
	@$(ARCH) format

analyze: ## Static analysis over lib, test and tool
	@$(ARCH) analyze

# Not a list of prerequisites: the order, and stopping at the first failure,
# are the command's own business — runVerify in tool/src/commands/quality.dart.
verify: ## Everything CI runs, in one command
	@$(ARCH) verify

##############################
### *** Tests *** ###
##############################

# Without KIND or LAYER, everything runs: the integrity suites, then the unit
# tests layer by layer, then widget and integration.
flutter-test: ## Run every test, live (KIND=unit|widget|integration, LAYER=<name>)
	@$(ARCH) test $(KIND) $(LAYER)

flutter-test-unit: ## test/unit only — every class in isolation (LAYER=<name>)
	@$(ARCH) test unit $(LAYER)

flutter-test-widget: ## test/widget only — screens and widgets, mocked
	@$(ARCH) test widget $(LAYER)

flutter-test-integration: ## test/integration only — real cross-layer flows
	@$(ARCH) test integration

# One scenario at a time, each one recorded: the frames, a video and the log
# land under .e2e-evidence/. With no SCENARIO it lists what there is, and what
# each one did the last time it ran.
flutter-test-e2e: ## The e2e scenarios (SCENARIO="<name>", ALL=1, DEVICE=<id>, WATCH=1)
	@$(ARCH) e2e $(if $(ALL),all) $(if $(DEVICE),--device=$(DEVICE)) \
		$(if $(WATCH),--watch) $(SCENARIO)

e2e-clean: ## Delete the recordings, keeping the record of what passed
	@$(ARCH) e2e clean

# Reads the import statements under lib/ and asserts the layer graph. The
# fastest answer to "did I just break a boundary".
flutter-test-arch: ## Assert the layer graph the imports actually declare
	@$(ARCH) test arch

flutter-test-cli: ## Test the arch CLI itself
	@$(ARCH) test cli

# Maps changed files to test files by name alone — a changed lib/foo.dart runs
# foo_test.dart. BASE=HEAD narrows it to uncommitted work.
flutter-test-diff: ## Test only what this branch's diff maps to (BASE=main)
	@$(ARCH) test diff $(if $(BASE),--base=$(BASE))

# Same mapping, different question: what the filesystem says you touched last,
# not what git says differs from a commit.
flutter-test-last: ## Test what the 10 most recently edited files map to (N=<count>)
	@$(ARCH) test last $(if $(N),--count=$(N))

coverage: ## Coverage report, rendered and opened in the browser (LAYER=<name>)
	@$(ARCH) coverage $(LAYER)

# The point is the suite that does not run: the test the file you just edited
# maps to, and the coverage of that file. Printed here, not rendered — the
# answer is three lines long.
coverage-last: ## Coverage of the file edited most recently, in the terminal (N=<count>)
	@$(ARCH) coverage last $(if $(N),--count=$(N))

coverage-diff: ## Coverage of what this branch changed, in the terminal (BASE=main)
	@$(ARCH) coverage diff $(if $(BASE),--base=$(BASE))

# A layer with no code yet, or with code nothing measured, is skipped rather
# than counted against: the gate is about tests falling behind code.
coverage-gate: ## Fail if any layer is under the coverage threshold (THRESHOLD=95)
	@$(ARCH) coverage-gate $(if $(THRESHOLD),--threshold=$(THRESHOLD))

##############################
### *** Codegen *** ###
##############################

runner: ## build_runner and gen-l10n over the tree
	@$(ARCH) codegen normal

runner-hard: ## Delete every generated file, then regenerate from scratch
	@$(ARCH) codegen hard

l10n: ## Regenerate the localizations and fail on a missing translation
	@$(ARCH) l10n

# Watch has no equivalent in the CLI and needs none: it is build_runner's own
# long-running mode, with nothing to orchestrate around it.
runner-watch: ## Regenerate continuously while you work
	dart run build_runner watch

# `codegen-gate` is a pipeline concern, so CI calls `arch codegen-gate`
# directly. Locally it arrives as one of the steps of `make verify`.

##############################
### *** Run & build *** ###
##############################

run: ## Run the app (DEVICE=<id> to choose one)
	@$(ARCH) run $(DEVICE)

build: ## Compile check for a release artifact (TARGET=apk|appbundle|ios)
	@$(ARCH) build $(TARGET)
