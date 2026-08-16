import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/shared_preferences/shared_preferences_impl.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> _unwrapList(Either<StorageFailure, List<String>> result) {
  expect(result.isRight(), isTrue);
  return result.getOrElse(() => <String>[]);
}

void main() {
  late SharedPreferencesImpl sut;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    sut = await SharedPreferencesImpl.create();
  });

  group('SharedPreferencesImpl — setters e getters', () {
    test('setString/getString deve persistir e recuperar valor', () async {
      await sut.setString(key: 'locale', value: 'pt');
      final Either<StorageFailure, String?> result = sut.getString(
        key: 'locale',
      );

      expect(result, const Right<StorageFailure, String?>('pt'));
    });

    test('getString deve retornar null para chave inexistente', () {
      final Either<StorageFailure, String?> result = sut.getString(
        key: 'inexistente',
      );

      expect(result, const Right<StorageFailure, String?>(null));
    });

    test('setBool/getBool deve persistir e recuperar valor', () async {
      await sut.setBool(key: 'darkMode', value: true);
      final Either<StorageFailure, bool?> result = sut.getBool(key: 'darkMode');

      expect(result, const Right<StorageFailure, bool?>(true));
    });

    test('getBool deve retornar null para chave inexistente', () {
      final Either<StorageFailure, bool?> result = sut.getBool(
        key: 'inexistente',
      );

      expect(result, const Right<StorageFailure, bool?>(null));
    });

    test('setDouble/getDouble deve persistir e recuperar valor', () async {
      await sut.setDouble(key: 'fontScale', value: 1.5);
      final Either<StorageFailure, double?> result = sut.getDouble(
        key: 'fontScale',
      );

      expect(result, const Right<StorageFailure, double?>(1.5));
    });

    test('setInt/getInt deve persistir e recuperar valor', () async {
      await sut.setInt(key: 'count', value: 42);
      final Either<StorageFailure, int?> result = sut.getInt(key: 'count');

      expect(result, const Right<StorageFailure, int?>(42));
    });
  });

  group('SharedPreferencesImpl — listas', () {
    test('setList/getList deve persistir e recuperar lista', () async {
      await sut.setList(
        key: 'favorites',
        value: <String>['BTCUSDT', 'ETHUSDT'],
      );
      final Either<StorageFailure, List<String>> result = sut.getList(
        key: 'favorites',
      );

      expect(_unwrapList(result), <String>['BTCUSDT', 'ETHUSDT']);
    });

    test('getList deve retornar lista vazia para chave inexistente', () {
      final Either<StorageFailure, List<String>> result = sut.getList(
        key: 'inexistente',
      );

      expect(_unwrapList(result), isEmpty);
    });

    test('addToList deve adicionar item à lista existente', () async {
      await sut.setList(key: 'favorites', value: <String>['BTCUSDT']);

      final Either<StorageFailure, List<String>> result = await sut.addToList(
        key: 'favorites',
        value: 'ETHUSDT',
      );

      expect(_unwrapList(result), <String>['BTCUSDT', 'ETHUSDT']);
    });

    test('addToList não deve duplicar item já existente', () async {
      await sut.setList(key: 'favorites', value: <String>['BTCUSDT']);

      final Either<StorageFailure, List<String>> result = await sut.addToList(
        key: 'favorites',
        value: 'BTCUSDT',
      );

      expect(_unwrapList(result), <String>['BTCUSDT']);
    });

    test('addToList deve criar lista quando chave não existe', () async {
      final Either<StorageFailure, List<String>> result = await sut.addToList(
        key: 'favorites',
        value: 'BTCUSDT',
      );

      expect(_unwrapList(result), <String>['BTCUSDT']);
    });

    test('removeFromList deve remover item da lista', () async {
      await sut.setList(
        key: 'favorites',
        value: <String>['BTCUSDT', 'ETHUSDT'],
      );

      final Either<StorageFailure, List<String>> result = await sut
          .removeFromList(key: 'favorites', value: 'BTCUSDT');

      expect(_unwrapList(result), <String>['ETHUSDT']);
    });

    test(
      'removeFromList em chave inexistente deve retornar lista vazia',
      () async {
        final Either<StorageFailure, List<String>> result = await sut
            .removeFromList(key: 'inexistente', value: 'BTCUSDT');

        expect(_unwrapList(result), isEmpty);
      },
    );
  });

  group('SharedPreferencesImpl — remove e clear', () {
    test('remove deve deletar a chave', () async {
      await sut.setString(key: 'locale', value: 'pt');
      await sut.remove(key: 'locale');

      final Either<StorageFailure, String?> result = sut.getString(
        key: 'locale',
      );

      expect(result, const Right<StorageFailure, String?>(null));
    });

    test('clear deve apagar todas as chaves', () async {
      await sut.setString(key: 'locale', value: 'pt');
      await sut.setBool(key: 'darkMode', value: true);

      await sut.clear();

      expect(
        sut.getString(key: 'locale'),
        const Right<StorageFailure, String?>(null),
      );
      expect(
        sut.getBool(key: 'darkMode'),
        const Right<StorageFailure, bool?>(null),
      );
    });
  });
}
