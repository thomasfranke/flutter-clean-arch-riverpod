/// The result of an operation that can fail: a [Left] carrying the failure,
/// or a [Right] carrying the value.
///
/// Written here rather than taken from `dartz`, which has not been released
/// since Dart 3 and predates sealed classes. Being `sealed` is the point: a
/// `switch` over an [Either] must handle both sides or it does not compile,
/// and pattern matching reads the value without a cast.
sealed class Either<L, R> {
  const Either();

  /// Collapses both sides into one value: [ifLeft] for a failure,
  /// [ifRight] for a value.
  B fold<B>(final B Function(L left) ifLeft, final B Function(R right) ifRight);

  /// Transforms the value, leaving a failure untouched.
  Either<L, R2> map<R2>(final R2 Function(R right) f) =>
      fold(Left<L, R2>.new, (final R right) => Right<L, R2>(f(right)));

  /// Transforms the failure, leaving a value untouched.
  Either<L2, R> leftMap<L2>(final L2 Function(L left) f) =>
      fold((final L left) => Left<L2, R>(f(left)), Right<L2, R>.new);

  /// Chains a second operation that can fail onto the value.
  Either<L, R2> flatMap<R2>(final Either<L, R2> Function(R right) f) =>
      fold(Left<L, R2>.new, f);

  /// Whether this is a failure.
  bool isLeft() => this is Left<L, R>;

  /// Whether this is a value.
  bool isRight() => this is Right<L, R>;

  /// The value, or [orElse]'s result for a failure.
  R getOrElse(final R Function() orElse) =>
      fold((_) => orElse(), (final R right) => right);
}

/// The failure side of an [Either].
final class Left<L, R> extends Either<L, R> {
  /// Wraps [value] as a failure.
  const Left(this.value);

  /// The failure.
  final L value;

  @override
  B fold<B>(
    final B Function(L left) ifLeft,
    final B Function(R right) ifRight,
  ) => ifLeft(value);

  // Equal across the other side's type, so `Left<Failure, Never>` — what a
  // generic helper can return — equals the `Left<Failure, List<X>>` a test
  // writes down.
  @override
  bool operator ==(final Object other) =>
      other is Left<Object?, Object?> && other.value == value;

  @override
  int get hashCode => Object.hash(Left<Object?, Object?>, value);

  @override
  String toString() => 'Left($value)';
}

/// The value side of an [Either].
final class Right<L, R> extends Either<L, R> {
  /// Wraps [value] as a success.
  const Right(this.value);

  /// The value.
  final R value;

  @override
  B fold<B>(
    final B Function(L left) ifLeft,
    final B Function(R right) ifRight,
  ) => ifRight(value);

  @override
  bool operator ==(final Object other) =>
      other is Right<Object?, Object?> && other.value == value;

  @override
  int get hashCode => Object.hash(Right<Object?, Object?>, value);

  @override
  String toString() => 'Right($value)';
}

/// Shorthand for `Left<L, R>(value)`, with the types inferred.
Either<L, R> left<L, R>(final L value) => Left<L, R>(value);

/// Shorthand for `Right<L, R>(value)`, with the types inferred.
Either<L, R> right<L, R>(final R value) => Right<L, R>(value);

/// The value of an operation that succeeds with nothing to say.
final class Unit {
  const Unit._();

  @override
  String toString() => '()';
}

/// The one [Unit].
const Unit unit = Unit._();
