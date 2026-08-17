####################################################################
###  *** Makefile for Flutter ***                                 ###
### To use these commands, type "make <command>" in the terminal ###
### Example: "make clean" to clean the project.                  ###
####################################################################

##############################
### *** Basic Commands *** ###
##############################

# Clean the project
clean:
	flutter clean
	flutter pub get

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

# Format Dart code
format:
	dart format --set-exit-if-changed .

# Build Runner: generates codegen files
runner:
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


#####################
### *** Tests *** ###
#####################

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
	flutter test --coverage test/unit
	genhtml coverage/lcov.info --output-directory coverage/html/unit
	open coverage/html/unit/index.html

# Run `flutter_test` widget tests only:
flutter-test-widget:
	flutter test --coverage test/widget
	genhtml coverage/lcov.info --output-directory coverage/html/widget
	open coverage/html/widget/index.html

# Run all e2e tests:
flutter-test-e2e:
	flutter test integration_test/