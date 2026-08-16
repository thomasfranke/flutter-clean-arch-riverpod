import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/get_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/save_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_locale_usecase.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPreferencesRepository extends Mock
    implements PreferencesRepository {}

void main() {
  late _MockPreferencesRepository repository;
  late GetPreferencesUseCase getPreferences;
  late SavePreferencesUseCase savePreferences;
  late UpdateLocaleUseCase sut;

  final PreferencesEntity tPreferences = PreferencesEntity.defaults();

  setUp(() {
    repository = _MockPreferencesRepository();
    getPreferences = GetPreferencesUseCase(repository: repository);
    savePreferences = SavePreferencesUseCase(repository: repository);
    sut = UpdateLocaleUseCase(
      getPreferences: getPreferences,
      savePreferences: savePreferences,
    );
    registerFallbackValue(tPreferences);
  });

  group('UpdateLocaleUseCase', () {
    test('deve buscar preferências, aplicar novo locale e salvar', () async {
      when(() => repository.getPreferences()).thenAnswer(
        (_) async => Right<Failure, PreferencesEntity>(tPreferences),
      );
      when(
        () => repository.savePreferences(any()),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

      final Either<Failure, Unit> result = await sut('en');

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => repository.getPreferences()).called(1);

      final PreferencesEntity captured =
          verify(() => repository.savePreferences(captureAny())).captured.first
              as PreferencesEntity;

      expect(captured.locale, 'en');
      expect(captured.darkMode, tPreferences.darkMode);
      expect(captured.fontScale, tPreferences.fontScale);
    });

    test('deve retornar Failure quando getPreferences falha', () async {
      when(() => repository.getPreferences()).thenAnswer(
        (_) async => const Left<Failure, PreferencesEntity>(Failure.storage()),
      );

      final Either<Failure, Unit> result = await sut('en');

      expect(result, const Left<Failure, Unit>(Failure.storage()));
      verifyNever(() => repository.savePreferences(any()));
    });

    test('deve retornar Failure quando savePreferences falha', () async {
      when(() => repository.getPreferences()).thenAnswer(
        (_) async => Right<Failure, PreferencesEntity>(tPreferences),
      );
      when(
        () => repository.savePreferences(any()),
      ).thenAnswer((_) async => const Left<Failure, Unit>(Failure.storage()));

      final Either<Failure, Unit> result = await sut('es');

      expect(result, const Left<Failure, Unit>(Failure.storage()));
    });
  });
}
