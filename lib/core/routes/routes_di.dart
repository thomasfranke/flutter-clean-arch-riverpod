import 'package:flutter_clean_arch_riverpod/core/routes/auto_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes_di.g.dart';

/// Provides the [AppRouter] implementation.
@riverpod
AppRouter appRouter(final Ref ref) => AppRouter();
