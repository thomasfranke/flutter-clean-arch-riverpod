import 'package:flutter_clean_arch_riverpod/application/quotes/get_klines_usecase.dart';
import 'package:flutter_clean_arch_riverpod/data/repositories_impl/kline_repository_impl_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_klines_usecase_di.g.dart';

/// Provides the [GetKlinesUseCase].
@riverpod
GetKlinesUseCase getKlinesUseCase(final Ref ref) =>
    GetKlinesUseCase(repository: ref.watch(klineRepositoryProvider));
