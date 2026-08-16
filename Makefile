####################################################################
###  *** Makefile for Flutter ***                                 ###
### To use these commands, type "make <command>" in the terminal ###
### Example: "make clean" to clean the project.                  ###
####################################################################

##############################
### *** Basic Commands *** ###
##############################

install-release:
	flutter build apk --release
	adb install -r build/app/outputs/flutter-apk/app-release.apk

# Clean the project
clean:
	flutter clean
	flutter pub get

# Export SQLite databases from simulator to project folder for debugging purposes.
db-export:
	for f in $$(adb exec-out run-as br.com.geosapiens.propesqmob sh -c 'cd databases && ls propesqmob_database*.db'); do \
		echo "Exporting $$f"; \
		adb exec-out run-as br.com.geosapiens.propesqmob cat databases/$$f > $$f; \
	done

# Run custom Dart tools (e.g., for checking submission IDs)
tools:
	dart run tool/check_submission_id.dart

# FVM: configures the Flutter environment for the app
fvm:
	dart pub global activate fvm
	fvm use 3.44.5
	fvm global 3.44.5
	dart pub global deactivate fvm
	dart pub global activate fvm


# Generates localization files (if l10n.yaml exists)
l10n:
	@test -f ./l10n.yaml && echo "Generating l10n..." && flutter gen-l10n || echo "No l10n.yaml file found."

# Build Runner: generates codegen files
runner:
	dart run build_runner build --delete-conflicting-outputs
runner-clean:
	dart run build_runner build --delete-conflicting-outputs
	flutter clean
	flutter pub get

# Build Runner: generates codegen files
runner-hard:
	find lib -name "*.freezed.dart" -delete
	find lib -name "*.g.dart" -delete
	find lib -name "*.gr.dart" -delete
	find lib -name "*.config.dart" -delete
	dart run build_runner build --delete-conflicting-outputs

# Build Runner Last: generates codegen files for files modified in the last 5 minutes
runner-last:
	@CHANGED_DIRS=$$(find lib test -name "*.dart" -type f -mmin -5 \
		! -name "*.g.dart" \
		! -name "*.freezed.dart" \
		! -name "*.gr.dart" | xargs -n1 dirname | sort -u); \
	if [ -n "$$CHANGED_DIRS" ]; then \
		echo "Running build_runner for directories of files modified in the last 5 minutes:"; \
		echo "$$CHANGED_DIRS" | tr ' ' '\n'; \
		BUILD_FILTERS=$$(echo "$$CHANGED_DIRS" | xargs -n1 -I{} echo --build-filter={}/** | tr '\n' ' '); \
		dart run build_runner build $$BUILD_FILTERS --delete-conflicting-outputs; \
	else \
		echo "No valid Dart source files modified in the last 5 minutes. Skipping build_runner."; \
	fi

# Build Runner Watch: generates codegen files in real time
runner-watch:
	dart pub run build_runner watch --delete-conflicting-outputs

# Prepare: sets up the environment for production build
prepare:
	$(MAKE) fvm
	$(MAKE) runner
	$(MAKE) l10n
	$(MAKE) clean

###########################################
### *** Tests -> `integration_test` *** ###
###########################################

# Run all integration tests:
flutter-integration-test:
	flutter test integration_test/

# Run `flutter_test` on files modified in the last 5 minutes:

flutter-integration-test-last:
	@LAST_FILES=$$(find ./integration_test -name "*.dart" -type f -mmin -5 -print | head -5); \
	if [ -n "$$LAST_FILES" ]; then \
		echo "Running integration tests on files modified in the last 5 minutes:"; \
		echo "$$LAST_FILES" | tr ' ' '\n'; \
		flutter test $$LAST_FILES; \
	else \
		echo "No .dart test files modified in the last 5 minutes in the 'integration_test/' folder."; \
	fi

######################################
### *** Tests -> `flutter_test` *** ###
######################################

# All `flutter_test` tests + coverage report:
flutter-test:
	flutter test --coverage
	genhtml coverage/lcov.info --output-directory coverage/html
	open ./coverage/html/index.html

# Run `flutter_test` integration tests only:
flutter-test-integration:
	flutter test --coverage test/integration
	genhtml coverage/lcov.info --output-directory coverage/html/integration
	open coverage/html/integration/index.html

# Run `flutter_test` unit tests only:
flutter-test-unit:
	flutter test --coverage test/unint
	genhtml coverage/lcov.info --output-directory coverage/html/unint
	open coverage/html/unint/index.html

# Run `flutter_test` widget tests only:
flutter-test-widget:
	flutter test --coverage test/widget
	genhtml coverage/lcov.info --output-directory coverage/html/widget
	open coverage/html/widget/index.html

# Run `flutter_test` on files modified in the last 5 minutes:
flutter-test-last:
	@LAST_FILES=$$(find ./test -name "*.dart" -type f -exec ls -t {} + 5>/dev/null | head -n 10); \
	if [ -n "$$LAST_FILES" ]; then \
		echo "Running tests on most recently modified files:"; \
		echo "$$LAST_FILES" | tr ' ' '\n'; \
		flutter test --no-color=false -r expanded $$LAST_FILES; \
	else \
		echo "No .dart test files found in the 'test/' folder."; \
	fi

# Run `flutter_test` on the last modified file and generate partial coverage:
flutter-test-last-coverage:
	@LAST_FILE=$$(find ./test -name "*.dart" -type f -exec ls -t {} + 2>/dev/null | head -n 1); \
	if [ -n "$$LAST_FILE" ]; then \
		echo "🧪 Running test (with coverage): $$LAST_FILE"; \
		flutter test --coverage --no-color=false -r expanded "$$LAST_FILE"; \
		if [ ! -s coverage/lcov.info ]; then \
			echo "⚠️  No coverage data generated (the test may not import code from lib/)."; \
		else \
			echo "\n📊 Impact on Coverage (top 5):"; \
			awk -F':' '\
				/^SF:/ {file=$$2; total=0; hit=0} \
				/^DA:/ {split($$2,a,","); total++; if(a[2]>0) hit++} \
				/^end_of_record/ { \
					if (total>0) { \
						pct=(hit/total)*100; \
						if (pct>0) printf "  %6.2f%%  %s\n", pct, file; \
					} \
				} \
			' coverage/lcov.info | sort -r -n | head -n 5; \
		fi \
	else \
		echo "No .dart test files found in the 'test/' folder."; \
	fi

#####################
### *** Build *** ###
#####################

# Build APK -> Manual Android distribution
apk:
	$(MAKE) prepare
	$(MAKE) apk-fast

# Build AppBundle -> For Google Play distribution
appbundle:
	$(MAKE) prepare
	$(MAKE) appbundle-fast

# Build IPA -> For App Store distribution
ipa:
	$(MAKE) prepare
	$(MAKE) ipa-fast

# Build Release -> AppBundle + IPA
release: 
	$(MAKE) prepare
	$(MAKE) apk-fast
	$(MAKE) appbundle-fast
	$(MAKE) ipa-fast

# Fast Builds (without full preparation)
apk-fast:
	flutter build apk --release
appbundle-fast:
	flutter build appbundle --release
ipa-fast:
	flutter build ipa

