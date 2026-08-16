import 'package:flutter_clean_arch_riverpod/data/data_sources/preferences_datasource_di.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/preferences_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/preferences_repository_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preferences_repository_impl_di.g.dart';

/// Riverpod provider for the [PreferencesRepositoryImpl].
@riverpod
PreferencesRepository preferencesRepository(Ref ref) =>
    PreferencesRepositoryImpl(
      datasource: ref.watch(preferencesDatasourceProvider),
    );
