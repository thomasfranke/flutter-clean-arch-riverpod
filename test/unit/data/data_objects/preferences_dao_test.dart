import 'package:flutter_clean_arch_riverpod/data/data_objects/preferences_dao.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PreferencesDAOMapper', () {
    test('should convert DAO to entity with present values', () {
      const PreferencesDAO dao = PreferencesDAO(
        locale: 'en',
        darkMode: true,
        fontScale: 1.5,
      );

      final PreferencesEntity entity = dao.toEntity();

      expect(entity.locale, 'en');
      expect(entity.darkMode, true);
      expect(entity.fontScale, 1.5);
    });

    test('should use defaults when fields are null', () {
      const PreferencesDAO dao = PreferencesDAO(
        locale: null,
        darkMode: null,
        fontScale: null,
      );
      final PreferencesEntity defaults = PreferencesEntity.defaults();

      final PreferencesEntity entity = dao.toEntity();

      expect(entity.locale, defaults.locale);
      expect(entity.darkMode, defaults.darkMode);
      expect(entity.fontScale, defaults.fontScale);
    });

    test('should use default only for null fields', () {
      final PreferencesEntity defaults = PreferencesEntity.defaults();
      const PreferencesDAO dao = PreferencesDAO(
        locale: 'es',
        darkMode: null,
        fontScale: null,
      );

      final PreferencesEntity entity = dao.toEntity();

      expect(entity.locale, 'es');
      expect(entity.darkMode, defaults.darkMode);
      expect(entity.fontScale, defaults.fontScale);
    });
  });
}
