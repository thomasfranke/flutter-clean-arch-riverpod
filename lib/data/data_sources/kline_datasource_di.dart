import 'package:flutter_clean_arch_riverpod/data/data_sources/kline_datasource.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/api_client/api_client_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'kline_datasource_di.g.dart';

/// Provides a Riverpod provider for the [KlineDatasource].
@riverpod
KlineDatasource klineDatasource(final Ref ref) =>
    KlineDatasource(apiClient: ref.watch(apiClientProvider));
