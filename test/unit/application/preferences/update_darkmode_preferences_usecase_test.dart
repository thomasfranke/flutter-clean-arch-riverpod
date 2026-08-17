import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_darkmode_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPreferencesRepository extends Mock
    implements PreferencesRepository {}

void main() {
  late _MockPreferencesRepository repository;
  late UpdateDarkModeUseCase sut;

  setUp(() {
    repository = _MockPreferencesRepository();
    sut = UpdateDarkModeUseCase(repository: repository);
  });

  group('UpdateDarkModeUseCase', () {
    test('should save only the darkMode', () async {
      when(
        () => repository.saveDarkMode(true),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

      final Either<Failure, Unit> result = await sut(true);

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => repository.saveDarkMode(true)).called(1);
    });

    test('should return Failure when saveDarkMode fails', () async {
      when(
        () => repository.saveDarkMode(false),
      ).thenAnswer((_) async => const Left<Failure, Unit>(Failure.storage()));

      final Either<Failure, Unit> result = await sut(false);

      expect(result, const Left<Failure, Unit>(Failure.storage()));
    });
  });
}
