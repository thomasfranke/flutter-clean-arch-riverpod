import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/shared_preferences/shared_preferences_impl.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

List<String> _unwrapList(Either<StorageFailure, List<String>> result) {
  expect(result.isRight(), isTrue);
  return result.getOrElse(() => <String>[]);
}

void _expectLeft<T>(Either<StorageFailure, T> result, StorageFailure failure) {
  expect(result, Left<StorageFailure, T>(failure));
}

/// A [SharedPreferencesStorePlatform] double whose mutating operations all
/// fail, used to exercise `SharedPreferencesImpl`'s error-handling paths
/// without needing to touch a real platform channel.
class _ThrowingSharedPreferencesStore extends SharedPreferencesStorePlatform {
  @override
  Future<Map<String, Object>> getAll() async => <String, Object>{};

  @override
  Future<bool> setValue(
    final String valueType,
    final String key,
    final Object value,
  ) => throw Exception('plugin unavailable');

  @override
  Future<bool> remove(final String key) =>
      throw Exception('plugin unavailable');

  @override
  Future<bool> clear() => throw Exception('plugin unavailable');
}

void main() {
  late SharedPreferencesImpl sut;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    sut = await SharedPreferencesImpl.create();
  });

  group('SharedPreferencesImpl — setters and getters', () {
    test('setString/getString should persist and retrieve value', () async {
      await sut.setString(key: 'locale', value: 'pt');
      final Either<StorageFailure, String?> result = sut.getString(
        key: 'locale',
      );

      expect(result, const Right<StorageFailure, String?>('pt'));
    });

    test('getString should return null for a non-existent key', () {
      final Either<StorageFailure, String?> result = sut.getString(
        key: 'inexistente',
      );

      expect(result, const Right<StorageFailure, String?>(null));
    });

    test('setBool/getBool should persist and retrieve value', () async {
      await sut.setBool(key: 'darkMode', value: true);
      final Either<StorageFailure, bool?> result = sut.getBool(key: 'darkMode');

      expect(result, const Right<StorageFailure, bool?>(true));
    });

    test('getBool should return null for a non-existent key', () {
      final Either<StorageFailure, bool?> result = sut.getBool(
        key: 'inexistente',
      );

      expect(result, const Right<StorageFailure, bool?>(null));
    });

    test('setDouble/getDouble should persist and retrieve value', () async {
      await sut.setDouble(key: 'fontScale', value: 1.5);
      final Either<StorageFailure, double?> result = sut.getDouble(
        key: 'fontScale',
      );

      expect(result, const Right<StorageFailure, double?>(1.5));
    });

    test('setInt/getInt should persist and retrieve value', () async {
      await sut.setInt(key: 'count', value: 42);
      final Either<StorageFailure, int?> result = sut.getInt(key: 'count');

      expect(result, const Right<StorageFailure, int?>(42));
    });
  });

  group('SharedPreferencesImpl — lists', () {
    test('setList/getList should persist and retrieve list', () async {
      await sut.setList(
        key: 'favorites',
        value: <String>['BTCUSDT', 'ETHUSDT'],
      );
      final Either<StorageFailure, List<String>> result = sut.getList(
        key: 'favorites',
      );

      expect(_unwrapList(result), <String>['BTCUSDT', 'ETHUSDT']);
    });

    test('getList should return an empty list for a non-existent key', () {
      final Either<StorageFailure, List<String>> result = sut.getList(
        key: 'inexistente',
      );

      expect(_unwrapList(result), isEmpty);
    });

    test('addToList should add item to the existing list', () async {
      await sut.setList(key: 'favorites', value: <String>['BTCUSDT']);

      final Either<StorageFailure, List<String>> result = await sut.addToList(
        key: 'favorites',
        value: 'ETHUSDT',
      );

      expect(_unwrapList(result), <String>['BTCUSDT', 'ETHUSDT']);
    });

    test('addToList should not duplicate an already-existing item', () async {
      await sut.setList(key: 'favorites', value: <String>['BTCUSDT']);

      final Either<StorageFailure, List<String>> result = await sut.addToList(
        key: 'favorites',
        value: 'BTCUSDT',
      );

      expect(_unwrapList(result), <String>['BTCUSDT']);
    });

    test(
      'addToList should create a list when the key does not exist',
      () async {
        final Either<StorageFailure, List<String>> result = await sut.addToList(
          key: 'favorites',
          value: 'BTCUSDT',
        );

        expect(_unwrapList(result), <String>['BTCUSDT']);
      },
    );

    test('removeFromList should remove item from the list', () async {
      await sut.setList(
        key: 'favorites',
        value: <String>['BTCUSDT', 'ETHUSDT'],
      );

      final Either<StorageFailure, List<String>> result = await sut
          .removeFromList(key: 'favorites', value: 'BTCUSDT');

      expect(_unwrapList(result), <String>['ETHUSDT']);
    });

    test(
      'removeFromList on a non-existent key should return an empty list',
      () async {
        final Either<StorageFailure, List<String>> result = await sut
            .removeFromList(key: 'inexistente', value: 'BTCUSDT');

        expect(_unwrapList(result), isEmpty);
      },
    );

    test('toggleInList should add when item is not in the list', () async {
      final Either<StorageFailure, List<String>> result = await sut
          .toggleInList(key: 'favorites', value: 'BTCUSDT');

      expect(_unwrapList(result), <String>['BTCUSDT']);
    });

    test(
      'toggleInList should remove when item is already in the list',
      () async {
        await sut.setList(key: 'favorites', value: <String>['BTCUSDT']);

        final Either<StorageFailure, List<String>> result = await sut
            .toggleInList(key: 'favorites', value: 'BTCUSDT');

        expect(_unwrapList(result), isEmpty);
      },
    );

    test('concurrent calls to addToList on the same key should not be lost '
        '(race condition)', () async {
      final List<Future<Either<StorageFailure, List<String>>>> calls =
          <Future<Either<StorageFailure, List<String>>>>[
            sut.addToList(key: 'favorites', value: 'BTCUSDT'),
            sut.addToList(key: 'favorites', value: 'ETHUSDT'),
          ];

      await Future.wait(calls);

      final Either<StorageFailure, List<String>> result = sut.getList(
        key: 'favorites',
      );

      expect(_unwrapList(result)..sort(), <String>['BTCUSDT', 'ETHUSDT']);
    });

    test('concurrent calls to toggleInList on the same key should be '
        'serialized', () async {
      await sut.setList(key: 'favorites', value: <String>[]);

      final List<Future<Either<StorageFailure, List<String>>>> calls =
          <Future<Either<StorageFailure, List<String>>>>[
            sut.toggleInList(key: 'favorites', value: 'BTCUSDT'),
            sut.toggleInList(key: 'favorites', value: 'BTCUSDT'),
          ];

      await Future.wait(calls);

      final Either<StorageFailure, List<String>> result = sut.getList(
        key: 'favorites',
      );

      expect(_unwrapList(result), isEmpty);
    });
  });

  group('SharedPreferencesImpl — remove and clear', () {
    test('remove should delete the key', () async {
      await sut.setString(key: 'locale', value: 'pt');
      await sut.remove(key: 'locale');

      final Either<StorageFailure, String?> result = sut.getString(
        key: 'locale',
      );

      expect(result, const Right<StorageFailure, String?>(null));
    });

    test('clear should erase all keys', () async {
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

  group('SharedPreferencesImpl — plugin failures when writing', () {
    setUp(() {
      SharedPreferencesStorePlatform.instance =
          _ThrowingSharedPreferencesStore();
    });

    test(
      'setString returns StorageFailure.write when the plugin fails',
      () async {
        _expectLeft(
          await sut.setString(key: 'locale', value: 'pt'),
          const StorageFailure.write(),
        );
      },
    );

    test(
      'setBool returns StorageFailure.write when the plugin fails',
      () async {
        _expectLeft(
          await sut.setBool(key: 'darkMode', value: true),
          const StorageFailure.write(),
        );
      },
    );

    test('setInt returns StorageFailure.write when the plugin fails', () async {
      _expectLeft(
        await sut.setInt(key: 'count', value: 1),
        const StorageFailure.write(),
      );
    });

    test(
      'setDouble returns StorageFailure.write when the plugin fails',
      () async {
        _expectLeft(
          await sut.setDouble(key: 'fontScale', value: 1.5),
          const StorageFailure.write(),
        );
      },
    );

    test(
      'setList returns StorageFailure.write when the plugin fails',
      () async {
        _expectLeft(
          await sut.setList(key: 'favorites', value: <String>['BTCUSDT']),
          const StorageFailure.write(),
        );
      },
    );

    test(
      'addToList returns StorageFailure.write when the plugin fails',
      () async {
        _expectLeft(
          await sut.addToList(key: 'favorites', value: 'BTCUSDT'),
          const StorageFailure.write(),
        );
      },
    );

    test(
      'removeFromList returns StorageFailure.write when the plugin fails',
      () async {
        _expectLeft(
          await sut.removeFromList(key: 'favorites', value: 'BTCUSDT'),
          const StorageFailure.write(),
        );
      },
    );

    test(
      'toggleInList returns StorageFailure.write when the plugin fails',
      () async {
        _expectLeft(
          await sut.toggleInList(key: 'favorites', value: 'BTCUSDT'),
          const StorageFailure.write(),
        );
      },
    );

    test(
      'remove returns StorageFailure.remove when the plugin fails',
      () async {
        _expectLeft(
          await sut.remove(key: 'locale'),
          const StorageFailure.remove(),
        );
      },
    );

    test('clear returns StorageFailure.clear when the plugin fails', () async {
      _expectLeft(await sut.clear(), const StorageFailure.clear());
    });
  });

  group('SharedPreferencesImpl — read failures (unexpected type)', () {
    test('getString returns StorageFailure.read when the stored value is not '
        'a String', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{'locale': true});
      sut = await SharedPreferencesImpl.create();

      _expectLeft(sut.getString(key: 'locale'), const StorageFailure.read());
    });

    test('getBool returns StorageFailure.read when the stored value is not a '
        'bool', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'darkMode': 'not-a-bool',
      });
      sut = await SharedPreferencesImpl.create();

      _expectLeft(sut.getBool(key: 'darkMode'), const StorageFailure.read());
    });

    test('getInt returns StorageFailure.read when the stored value is not an '
        'int', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'count': 'not-an-int',
      });
      sut = await SharedPreferencesImpl.create();

      _expectLeft(sut.getInt(key: 'count'), const StorageFailure.read());
    });

    test('getDouble returns StorageFailure.read when the stored value is not '
        'a double', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'fontScale': 'not-a-double',
      });
      sut = await SharedPreferencesImpl.create();

      _expectLeft(sut.getDouble(key: 'fontScale'), const StorageFailure.read());
    });

    test('getList returns StorageFailure.read when the stored value is not a '
        'list', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'favorites': 'not-a-list',
      });
      sut = await SharedPreferencesImpl.create();

      _expectLeft(sut.getList(key: 'favorites'), const StorageFailure.read());
    });
  });
}
