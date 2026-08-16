import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/core/routes/auto_route.dart';
import 'package:flutter_clean_arch_riverpod/core/routes/routes_di.dart';
import 'package:flutter_clean_arch_riverpod/core/theme/app_theme.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/shared_preferences/shared_preferences_impl.dart';
import 'package:flutter_clean_arch_riverpod/infrastructure/storage/storage_di.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/preferences/preferences_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/preferences/preferences_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferencesImpl sharedPreferences =
      await SharedPreferencesImpl.create();

  runApp(
    ProviderScope(
      overrides: <Override>[
        storageProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

/// Root widget of the application.
class MyApp extends ConsumerWidget {
  /// Creates an instance of the root widget of the application.
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final AppRouter appRouter = ref.watch(appRouterProvider);
    final PreferencesState preferencesState = ref.watch(preferencesProvider);

    final PreferencesEntity preferences = switch (preferencesState) {
      PreferencesStateSuccess(:final PreferencesEntity preferences) =>
        preferences,
      _ => PreferencesEntity.defaults(),
    };
    return MaterialApp.router(
      /// Auto Route Configuration:
      routerConfig: appRouter.config(),
      debugShowCheckedModeBanner: false,

      /// Font Size:
      builder: (final BuildContext context, final Widget? child) {
        final double fontScale = preferences.fontScale;
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(fontScale)),
          child: child!,
        );
      },

      /// l10n:
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(preferences.locale),

      /// Theme
      themeMode: preferences.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme().light,
      darkTheme: AppTheme().dark,
    );
  }
}
