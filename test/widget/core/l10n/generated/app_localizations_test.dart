import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations_en.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations_es.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations_pt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocalizationsEn', () {
    final AppLocalizationsEn l10n = AppLocalizationsEn();

    test('exposes all English translations', () {
      expect(l10n.quotes, 'Quotes');
      expect(l10n.settings, 'Settings');
      expect(l10n.darkMode, 'Dark Mode');
      expect(l10n.fontSize, 'Font Size');
      expect(l10n.favorites, 'Favorites');
      expect(l10n.filterBySymbol, 'Filter by symbol...');
      expect(l10n.language, 'Language');
      expect(l10n.lastPrice, 'Last Price');
      expect(l10n.priceChange24h, 'Price Change 24h');
      expect(l10n.absoluteChange, 'Absolute Change');
      expect(l10n.high24h, 'High 24h');
      expect(l10n.low24h, 'Low 24h');
      expect(l10n.baseVolume, 'Base Volume');
      expect(l10n.quoteVolume, 'Quote Volume');
      expect(l10n.appearance, 'Appearance');
      expect(l10n.priceHistory, 'Price History');
      expect(l10n.noFavoritesYet, 'No favorites yet');
      expect(l10n.noData, 'No data');
    });

    test('localeName is derived from the given locale', () {
      expect(l10n.localeName, 'en');
      expect(AppLocalizationsEn('en_US').localeName, 'en_US');
    });
  });

  group('AppLocalizationsEs', () {
    final AppLocalizationsEs l10n = AppLocalizationsEs();

    test('exposes all Spanish translations', () {
      expect(l10n.quotes, 'Cotizaciones');
      expect(l10n.settings, 'Configuración');
      expect(l10n.darkMode, 'Modo Oscuro');
      expect(l10n.fontSize, 'Tamaño de Fuente');
      expect(l10n.favorites, 'Favoritos');
      expect(l10n.filterBySymbol, 'Filtrar por Símbolo');
      expect(l10n.language, 'Idioma');
      expect(l10n.lastPrice, 'Último Precio');
      expect(l10n.priceChange24h, 'Variación 24h');
      expect(l10n.absoluteChange, 'Variación Absoluta');
      expect(l10n.high24h, 'Máximo 24h');
      expect(l10n.low24h, 'Mínimo 24h');
      expect(l10n.baseVolume, 'Volumen Base');
      expect(l10n.quoteVolume, 'Volumen Quote');
      expect(l10n.appearance, 'Apariencia');
      expect(l10n.priceHistory, 'Historial de Precio');
      expect(l10n.noFavoritesYet, 'Aún no hay favoritos');
      expect(l10n.noData, 'Sin datos');
    });
  });

  group('AppLocalizationsPt', () {
    final AppLocalizationsPt l10n = AppLocalizationsPt();

    test('exposes all Portuguese translations', () {
      expect(l10n.quotes, 'Cotações');
      expect(l10n.settings, 'Configurações');
      expect(l10n.darkMode, 'Modo Escuro');
      expect(l10n.fontSize, 'Tamanho de Fonte');
      expect(l10n.favorites, 'Favoritos');
      expect(l10n.filterBySymbol, 'Filtrar por Símbolo');
      expect(l10n.language, 'Idioma');
      expect(l10n.lastPrice, 'Último Preço');
      expect(l10n.priceChange24h, 'Variação 24h');
      expect(l10n.absoluteChange, 'Variação Absoluta');
      expect(l10n.high24h, 'Máxima 24h');
      expect(l10n.low24h, 'Mínima 24h');
      expect(l10n.baseVolume, 'Volume Base');
      expect(l10n.quoteVolume, 'Volume Quote');
      expect(l10n.appearance, 'Aparência');
      expect(l10n.priceHistory, 'Histórico de Preço');
      expect(l10n.noFavoritesYet, 'Nenhum favorito ainda');
      expect(l10n.noData, 'Sem dados');
    });
  });

  group('AppLocalizations', () {
    test(
      'localizationsDelegates includes the app delegate and the global ones',
      () {
        expect(
          AppLocalizations.localizationsDelegates,
          contains(AppLocalizations.delegate),
        );
        expect(AppLocalizations.localizationsDelegates.length, 4);
      },
    );

    test('supportedLocales contains en, es and pt', () {
      expect(AppLocalizations.supportedLocales, <Locale>[
        const Locale('en'),
        const Locale('es'),
        const Locale('pt'),
      ]);
    });

    test('lookupAppLocalizations resolves the correct class per language', () {
      expect(
        lookupAppLocalizations(const Locale('en')),
        isA<AppLocalizationsEn>(),
      );
      expect(
        lookupAppLocalizations(const Locale('es')),
        isA<AppLocalizationsEs>(),
      );
      expect(
        lookupAppLocalizations(const Locale('pt')),
        isA<AppLocalizationsPt>(),
      );
    });

    test(
      'lookupAppLocalizations throws FlutterError for an unsupported language',
      () {
        expect(
          () => lookupAppLocalizations(const Locale('xx')),
          throwsA(isA<FlutterError>()),
        );
      },
    );

    test('delegate.isSupported reflects the supported languages', () {
      expect(AppLocalizations.delegate.isSupported(const Locale('en')), true);
      expect(AppLocalizations.delegate.isSupported(const Locale('xx')), false);
    });

    test('delegate.load resolves the AppLocalizations instance', () async {
      final AppLocalizations result = await AppLocalizations.delegate.load(
        const Locale('pt'),
      );

      expect(result, isA<AppLocalizationsPt>());
    });

    test('delegate.shouldReload never requests a reload', () {
      expect(
        AppLocalizations.delegate.shouldReload(AppLocalizations.delegate),
        false,
      );
    });

    testWidgets('AppLocalizations.of resolves the instance from the context', (
      final WidgetTester tester,
    ) async {
      late AppLocalizations resolved;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (final BuildContext context) {
              resolved = AppLocalizations.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolved, isA<AppLocalizationsEn>());
    });
  });
}
