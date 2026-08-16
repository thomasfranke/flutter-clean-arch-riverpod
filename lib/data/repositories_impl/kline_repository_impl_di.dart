import 'package:flutter_clean_arch_riverpod/data/data_sources/kline_datasource_di.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/kline_repository_impl.dart';
import 'package:flutter_clean_arch_riverpod/domain/repositories/kline_repository_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'kline_repository_impl_di.g.dart';

/// Provides the [KlineRepository] implementation.
@riverpod
KlineRepository klineRepository(final Ref ref) =>
    KlineRepositoryImpl(datasource: ref.watch(klineDatasourceProvider));
