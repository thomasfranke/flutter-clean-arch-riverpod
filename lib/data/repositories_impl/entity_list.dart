import 'dart:developer';

import 'package:flutter_clean_arch_riverpod/core/either/either.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';

/// Converts every DTO in [dtos] with [convert], keeping the ones that convert.
///
/// A row that does not convert is dropped and counted in the log, under
/// [source], rather than shown with zeros in place of its numbers. If rows
/// arrived and none converted, the payload is not what the endpoint is
/// documented to return, and the result is [Failure.parse].
Either<Failure, List<E>> toEntities<D, E>(
  final List<D> dtos,
  final E? Function(D dto) convert, {
  required final String source,
}) {
  final List<E> entities = <E>[for (final D dto in dtos) ?convert(dto)];
  final int dropped = dtos.length - entities.length;
  if (dropped > 0) {
    log('Dropped $dropped of ${dtos.length} malformed rows', name: source);
  }
  if (dtos.isNotEmpty && entities.isEmpty) {
    return const Left<Failure, Never>(Failure.parse());
  }
  return Right<Failure, List<E>>(entities);
}

/// [convert] applied to a single DTO, with a refusal reported as
/// [Failure.parse].
Either<Failure, E> toEntity<D, E>(
  final D dto,
  final E? Function(D dto) convert,
) => switch (convert(dto)) {
  final E entity => Right<Failure, E>(entity),
  _ => const Left<Failure, Never>(Failure.parse()),
};
