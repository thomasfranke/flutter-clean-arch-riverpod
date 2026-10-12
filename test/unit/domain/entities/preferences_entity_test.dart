import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PreferencesEntity', () {
    test('should hold the values it was given', () {
      const PreferencesEntity preferences = PreferencesEntity(
        locale: 'en',
        darkMode: true,
        fontScale: 1.5,
      );

      expect(preferences.locale, 'en');
      expect(preferences.darkMode, true);
      expect(preferences.fontScale, 1.5);
    });

    test('defaults should be Portuguese, light and unscaled', () {
      // Pinned rather than read back from the entity: these are what the app
      // draws its first frame with, before storage has answered.
      final PreferencesEntity defaults = PreferencesEntity.defaults();

      expect(defaults.locale, 'pt');
      expect(defaults.darkMode, false);
      expect(defaults.fontScale, 1);
    });

    test('should be equal to another with the same values', () {
      const PreferencesEntity one = PreferencesEntity(
        locale: 'es',
        darkMode: false,
        fontScale: 1.2,
      );
      const PreferencesEntity other = PreferencesEntity(
        locale: 'es',
        darkMode: false,
        fontScale: 1.2,
      );

      expect(one, other);
      expect(one.hashCode, other.hashCode);
    });

    test('should copy one field, keeping the rest', () {
      final PreferencesEntity defaults = PreferencesEntity.defaults();

      final PreferencesEntity dark = defaults.copyWith(darkMode: true);

      expect(dark.darkMode, true);
      expect(dark.locale, defaults.locale);
      expect(dark.fontScale, defaults.fontScale);
      expect(defaults.darkMode, false);
    });
  });
}
