import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_locale_usecase.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPreferencesRepository extends Mock
    implements PreferencesRepository {}

void main() {
  late _MockPreferencesRepository repository;
  late UpdateLocaleUseCase sut;

  setUp(() {
    repository = _MockPreferencesRepository();
    sut = UpdateLocaleUseCase(repository: repository);
  });

  group('UpdateLocaleUseCase', () {
    test('should save only the locale', () async {
      when(
        () => repository.saveLocale('en'),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

      final Either<Failure, Unit> result = await sut('en');

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => repository.saveLocale('en')).called(1);
    });

    test('should return Failure when saveLocale fails', () async {
      when(
        () => repository.saveLocale('es'),
      ).thenAnswer((_) async => const Left<Failure, Unit>(Failure.storage()));

      final Either<Failure, Unit> result = await sut('es');

      expect(result, const Left<Failure, Unit>(Failure.storage()));
    });
  });
}
