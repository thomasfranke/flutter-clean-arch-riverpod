import 'package:flutter_clean_arch_riverpod/core/failures/failure.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/preferences/preferences_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PreferencesState', () {
    test('should offer the four cases every screen switches over', () {
      // Spelled out rather than read back. The screens are a `switch` over
      // these four, and a case added or dropped changes what a screen has to
      // draw — which is the kind of change worth failing a test.
      expect(const PreferencesState.initial(), isA<PreferencesState>());
      expect(const PreferencesState.loading(), isA<PreferencesState>());
      expect(
        PreferencesState.success(PreferencesEntity.defaults()),
        isA<PreferencesStateSuccess>(),
      );
      expect(
        const PreferencesState.failure(Failure.parse()),
        isA<PreferencesState>(),
      );
    });

    test('should carry the value the success case was given', () {
      final PreferencesStateSuccess success =
          PreferencesState.success(PreferencesEntity.defaults())
              as PreferencesStateSuccess;

      expect(success.preferences, PreferencesEntity.defaults());
    });

    test('should carry the failure the failure case was given', () {
      const PreferencesState state = PreferencesState.failure(
        Failure.storage(),
      );

      expect(state, const PreferencesState.failure(Failure.storage()));
      expect(state, isNot(const PreferencesState.failure(Failure.parse())));
    });

    test('should tell the empty cases apart', () {
      // `initial` is "nothing asked yet" and `loading` is "asked, waiting".
      // Equal, a notifier could not keep the last good value by testing for
      // one of them.
      expect(
        const PreferencesState.initial(),
        isNot(const PreferencesState.loading()),
      );
    });

    test('should compare two successes by what they hold', () {
      expect(
        PreferencesState.success(PreferencesEntity.defaults()),
        PreferencesState.success(PreferencesEntity.defaults()),
      );
      expect(
        PreferencesState.success(PreferencesEntity.defaults()),
        isNot(
          PreferencesState.success(
            PreferencesEntity.defaults().copyWith(darkMode: true),
          ),
        ),
      );
    });
  });
}
