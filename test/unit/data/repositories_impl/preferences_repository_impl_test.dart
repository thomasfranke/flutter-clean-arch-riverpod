import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/preferences_dao.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/preferences_datasource.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPreferencesDatasource extends Mock
    implements PreferencesDatasource {}

void main() {
  group('PreferencesRepositoryImpl', () {
    late _MockPreferencesDatasource datasource;
    late PreferencesRepositoryImpl sut;

    final PreferencesEntity tPreferences = PreferencesEntity.defaults();
    final PreferencesDAO tDAO = PreferencesDAO(
      locale: tPreferences.locale,
      darkMode: tPreferences.darkMode,
      fontScale: tPreferences.fontScale,
    );

    setUp(() {
      datasource = _MockPreferencesDatasource();
      sut = PreferencesRepositoryImpl(datasource: datasource);
    });

    test('should convert DAO into PreferencesEntity', () async {
      when(
        () => datasource.getPreferences(),
      ).thenReturn(Right<Failure, PreferencesDAO>(tDAO));

      final Either<Failure, PreferencesEntity> result = await sut
          .getPreferences();

      expect(result, Right<Failure, PreferencesEntity>(tPreferences));
    });

    test('should propagate Failure from getPreferences', () async {
      when(
        () => datasource.getPreferences(),
      ).thenReturn(const Left<Failure, PreferencesDAO>(Failure.storage()));

      final Either<Failure, PreferencesEntity> result = await sut
          .getPreferences();

      expect(result, const Left<Failure, PreferencesEntity>(Failure.storage()));
    });

    test('should delegate saveLocale to the datasource', () async {
      when(
        () => datasource.saveLocale('en'),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

      final Either<Failure, Unit> result = await sut.saveLocale('en');

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => datasource.saveLocale('en')).called(1);
    });

    test('should delegate saveDarkMode to the datasource', () async {
      when(
        () => datasource.saveDarkMode(true),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

      final Either<Failure, Unit> result = await sut.saveDarkMode(true);

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => datasource.saveDarkMode(true)).called(1);
    });

    test('should delegate saveFontScale to the datasource', () async {
      when(
        () => datasource.saveFontScale(1.5),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

      final Either<Failure, Unit> result = await sut.saveFontScale(1.5);

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => datasource.saveFontScale(1.5)).called(1);
    });
  });
}
