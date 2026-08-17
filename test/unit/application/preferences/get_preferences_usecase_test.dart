import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/application/preferences/get_preferences_usecase.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPreferencesRepository extends Mock
    implements PreferencesRepository {}

void main() {
  late _MockPreferencesRepository repository;
  late GetPreferencesUseCase sut;

  final PreferencesEntity tPreferences = PreferencesEntity.defaults();

  setUp(() {
    repository = _MockPreferencesRepository();
    sut = GetPreferencesUseCase(repository: repository);
  });

  group('GetPreferencesUseCase', () {
    test('should delegate to repository.getPreferences', () async {
      when(() => repository.getPreferences()).thenAnswer(
        (_) async => Right<Failure, PreferencesEntity>(tPreferences),
      );

      final Either<Failure, PreferencesEntity> result = await sut();

      expect(result, Right<Failure, PreferencesEntity>(tPreferences));
      verify(() => repository.getPreferences()).called(1);
    });

    test('should return Failure when the repository fails', () async {
      when(() => repository.getPreferences()).thenAnswer(
        (_) async => const Left<Failure, PreferencesEntity>(Failure.storage()),
      );

      final Either<Failure, PreferencesEntity> result = await sut();

      expect(result, const Left<Failure, PreferencesEntity>(Failure.storage()));
    });
  });
}
