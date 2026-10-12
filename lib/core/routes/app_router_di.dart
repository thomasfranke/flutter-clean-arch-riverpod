import 'package:flutter_clean_arch_riverpod/core/routes/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router_di.g.dart';

/// Provides the [AppRouter] implementation.
@riverpod
AppRouter appRouter(final Ref ref) => AppRouter();
