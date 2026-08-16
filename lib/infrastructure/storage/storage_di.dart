import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_di.g.dart';

/// Provides the [StorageInterface] implementation.
/// Storage provider that needs to be overridden in the main app.
/// Used for testing purposes.
@riverpod
StorageInterface storage(final Ref ref) {
  throw UnimplementedError();
}
