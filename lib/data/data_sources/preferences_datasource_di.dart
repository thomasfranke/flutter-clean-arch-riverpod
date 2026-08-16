import 'package:flutter_clean_arch_riverpod/data/data_sources/preferences_datasource.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preferences_datasource_di.g.dart';

/// Provides a Riverpod provider for the [PreferencesDatasource].
@riverpod
PreferencesDatasource preferencesDatasource(Ref ref) =>
    PreferencesDatasource(storage: ref.watch(storageProvider));
