import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/update_fontscale_usecase.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPreferencesRepository extends Mock
    implements PreferencesRepository {}

void main() {
  late _MockPreferencesRepository repository;
  late UpdateFontScaleUseCase sut;

  setUp(() {
    repository = _MockPreferencesRepository();
    sut = UpdateFontScaleUseCase(repository: repository);
  });

  group('UpdateFontScaleUseCase', () {
    test('should save only the fontScale', () async {
      when(
        () => repository.saveFontScale(1.5),
      ).thenAnswer((_) async => const Right<Failure, Unit>(unit));

      final Either<Failure, Unit> result = await sut(1.5);

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => repository.saveFontScale(1.5)).called(1);
    });

    test('should return Failure when saveFontScale fails', () async {
      when(
        () => repository.saveFontScale(2),
      ).thenAnswer((_) async => const Left<Failure, Unit>(Failure.storage()));

      final Either<Failure, Unit> result = await sut(2);

      expect(result, const Left<Failure, Unit>(Failure.storage()));
    });
  });
}
