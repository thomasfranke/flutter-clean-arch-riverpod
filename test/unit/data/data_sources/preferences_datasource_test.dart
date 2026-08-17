import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/data/data_objects/preferences_dao.dart';
import 'package:flutter_clean_arch_riverpod/data/data_sources/preferences_datasource.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements StorageInterface {}

void main() {
  late _MockStorage storage;
  late PreferencesDatasource sut;

  setUp(() {
    storage = _MockStorage();
    sut = PreferencesDatasource(storage: storage);
  });

  void stubHappyPath() {
    when(
      () => storage.getString(key: 'pref_locale'),
    ).thenReturn(const Right<StorageFailure, String?>('en'));
    when(
      () => storage.getBool(key: 'pref_dark_mode'),
    ).thenReturn(const Right<StorageFailure, bool?>(true));
    when(
      () => storage.getDouble(key: 'pref_font_scale'),
    ).thenReturn(const Right<StorageFailure, double?>(1.5));
  }

  group('getPreferences', () {
    test(
      'should combine locale, darkMode and fontScale into a PreferencesDAO',
      () {
        stubHappyPath();

        final Either<Failure, PreferencesDAO> result = sut.getPreferences();

        expect(result.isRight(), isTrue);
        final PreferencesDAO dao = result.getOrElse(
          () => throw StateError('expected Right'),
        );
        expect(dao.locale, 'en');
        expect(dao.darkMode, true);
        expect(dao.fontScale, 1.5);
      },
    );

    test('should return Failure immediately when reading the locale fails, '
        'without checking darkMode/fontScale', () {
      when(
        () => storage.getString(key: 'pref_locale'),
      ).thenReturn(const Left<StorageFailure, String?>(StorageFailure.read()));

      final Either<Failure, PreferencesDAO> result = sut.getPreferences();

      expect(result, const Left<Failure, PreferencesDAO>(Failure.storage()));
      verifyNever(() => storage.getBool(key: 'pref_dark_mode'));
      verifyNever(() => storage.getDouble(key: 'pref_font_scale'));
    });

    test('should return Failure immediately when reading darkMode fails, '
        'without checking fontScale', () {
      when(
        () => storage.getString(key: 'pref_locale'),
      ).thenReturn(const Right<StorageFailure, String?>('en'));
      when(
        () => storage.getBool(key: 'pref_dark_mode'),
      ).thenReturn(const Left<StorageFailure, bool?>(StorageFailure.read()));

      final Either<Failure, PreferencesDAO> result = sut.getPreferences();

      expect(result, const Left<Failure, PreferencesDAO>(Failure.storage()));
      verifyNever(() => storage.getDouble(key: 'pref_font_scale'));
    });

    test('should return Failure when reading fontScale fails', () {
      when(
        () => storage.getString(key: 'pref_locale'),
      ).thenReturn(const Right<StorageFailure, String?>('en'));
      when(
        () => storage.getBool(key: 'pref_dark_mode'),
      ).thenReturn(const Right<StorageFailure, bool?>(true));
      when(
        () => storage.getDouble(key: 'pref_font_scale'),
      ).thenReturn(const Left<StorageFailure, double?>(StorageFailure.read()));

      final Either<Failure, PreferencesDAO> result = sut.getPreferences();

      expect(result, const Left<Failure, PreferencesDAO>(Failure.storage()));
    });
  });

  group('saveLocale', () {
    test('should write only the "pref_locale" key', () async {
      when(
        () => storage.setString(key: 'pref_locale', value: 'es'),
      ).thenAnswer((_) async => const Right<StorageFailure, Unit>(unit));

      final Either<Failure, Unit> result = await sut.saveLocale('es');

      expect(result, const Right<Failure, Unit>(unit));
      verify(
        () => storage.setString(key: 'pref_locale', value: 'es'),
      ).called(1);
    });

    test('should propagate StorageFailure as a domain Failure', () async {
      when(() => storage.setString(key: 'pref_locale', value: 'es')).thenAnswer(
        (_) async => const Left<StorageFailure, Unit>(StorageFailure.write()),
      );

      final Either<Failure, Unit> result = await sut.saveLocale('es');

      expect(result, const Left<Failure, Unit>(Failure.storage()));
    });
  });

  group('saveDarkMode', () {
    test('should write only the "pref_dark_mode" key', () async {
      when(
        () => storage.setBool(key: 'pref_dark_mode', value: true),
      ).thenAnswer((_) async => const Right<StorageFailure, Unit>(unit));

      final Either<Failure, Unit> result = await sut.saveDarkMode(true);

      expect(result, const Right<Failure, Unit>(unit));
      verify(
        () => storage.setBool(key: 'pref_dark_mode', value: true),
      ).called(1);
    });

    test('should propagate StorageFailure as a domain Failure', () async {
      when(
        () => storage.setBool(key: 'pref_dark_mode', value: true),
      ).thenAnswer(
        (_) async => const Left<StorageFailure, Unit>(StorageFailure.write()),
      );

      final Either<Failure, Unit> result = await sut.saveDarkMode(true);

      expect(result, const Left<Failure, Unit>(Failure.storage()));
    });
  });

  group('saveFontScale', () {
    test('should write only the "pref_font_scale" key', () async {
      when(
        () => storage.setDouble(key: 'pref_font_scale', value: 1.2),
      ).thenAnswer((_) async => const Right<StorageFailure, Unit>(unit));

      final Either<Failure, Unit> result = await sut.saveFontScale(1.2);

      expect(result, const Right<Failure, Unit>(unit));
      verify(
        () => storage.setDouble(key: 'pref_font_scale', value: 1.2),
      ).called(1);
    });

    test('should propagate StorageFailure as a domain Failure', () async {
      when(
        () => storage.setDouble(key: 'pref_font_scale', value: 1.2),
      ).thenAnswer(
        (_) async => const Left<StorageFailure, Unit>(StorageFailure.write()),
      );

      final Either<Failure, Unit> result = await sut.saveFontScale(1.2);

      expect(result, const Left<Failure, Unit>(Failure.storage()));
    });
  });
}
