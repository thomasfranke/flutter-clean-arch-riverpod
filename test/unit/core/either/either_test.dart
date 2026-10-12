import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Either<String, int> ok = Right<String, int>(2);
  const Either<String, int> err = Left<String, int>('boom');

  group('Either', () {
    test('fold takes the side that is there', () {
      expect(ok.fold((_) => 'left', (final int v) => 'right $v'), 'right 2');
      expect(
        err.fold((final String e) => 'left $e', (_) => 'right'),
        'left boom',
      );
    });

    test('map transforms a value and leaves a failure alone', () {
      expect(ok.map((final int v) => v * 10), const Right<String, int>(20));
      expect(err.map((final int v) => v * 10), const Left<String, int>('boom'));
    });

    test('leftMap transforms a failure and leaves a value alone', () {
      expect(
        err.leftMap((final String e) => e.length),
        const Left<int, int>(4),
      );
      expect(
        ok.leftMap((final String e) => e.length),
        const Right<int, int>(2),
      );
    });

    test('flatMap chains, and stops at the first failure', () {
      Either<String, int> half(final int v) => v.isEven
          ? Right<String, int>(v ~/ 2)
          : const Left<String, int>('odd');

      expect(ok.flatMap(half), const Right<String, int>(1));
      expect(ok.flatMap(half).flatMap(half), const Left<String, int>('odd'));
      expect(err.flatMap(half), const Left<String, int>('boom'));
    });

    test('isLeft and isRight say which side it is', () {
      expect(ok.isRight(), isTrue);
      expect(ok.isLeft(), isFalse);
      expect(err.isLeft(), isTrue);
      expect(err.isRight(), isFalse);
    });

    test('getOrElse is the value, or the fallback for a failure', () {
      expect(ok.getOrElse(() => -1), 2);
      expect(err.getOrElse(() => -1), -1);
    });

    test('a switch reads the value without a cast', () {
      final String described = switch (err) {
        Left<String, int>(:final String value) => 'failed: $value',
        Right<String, int>(:final int value) => 'got $value',
      };

      expect(described, 'failed: boom');
    });

    test('equality is by side and value, not by the other type', () {
      expect(const Left<String, Never>('boom'), err);
      expect(const Left<String, int>('boom').hashCode, err.hashCode);
      expect(const Right<Never, int>(2), ok);
      expect(const Right<String, int>(2).hashCode, ok.hashCode);
      expect(err, isNot(const Right<String, String>('boom')));
      expect(ok, isNot(const Left<int, int>(2)));
    });

    test('left and right infer their types', () {
      expect(left<String, int>('boom'), err);
      expect(right<String, int>(2), ok);
    });

    test('toString names the side', () {
      expect(ok.toString(), 'Right(2)');
      expect(err.toString(), 'Left(boom)');
      expect(unit.toString(), '()');
    });
  });
}
