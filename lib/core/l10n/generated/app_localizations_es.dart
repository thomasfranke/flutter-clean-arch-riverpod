// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get quotes => 'Cotizaciones';

  @override
  String get settings => 'Configuración';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get fontSize => 'Tamaño de Fuente';

  @override
  String get favorites => 'Favoritos';

  @override
  String get filterBySymbol => 'Filtrar por Símbolo';

  @override
  String get language => 'Idioma';

  @override
  String get lastPrice => 'Último Precio';

  @override
  String get priceChange24h => 'Variación 24h';

  @override
  String get absoluteChange => 'Variación Absoluta';

  @override
  String get high24h => 'Máximo 24h';

  @override
  String get low24h => 'Mínimo 24h';

  @override
  String get baseVolume => 'Volumen Base';

  @override
  String get quoteVolume => 'Volumen Quote';

  @override
  String get appearance => 'Apariencia';

  @override
  String get priceHistory => 'Historial de Precio';

  @override
  String get noFavoritesYet => 'Aún no hay favoritos';

  @override
  String get noData => 'Sin datos';

  @override
  String get failureNetwork =>
      'Sin conexión. Revisa tu internet e inténtalo de nuevo.';

  @override
  String get failureServer =>
      'El servidor tiene problemas. Inténtalo de nuevo en un momento.';

  @override
  String get failureNotFound => 'No se encontró nada para esta solicitud.';

  @override
  String get failureClient => 'La solicitud fue rechazada.';

  @override
  String get failureParse => 'No se pudieron leer los datos recibidos.';

  @override
  String get failureStorage =>
      'No se pudo acceder a los datos guardados en este dispositivo.';

  @override
  String get failureUnexpected => 'Algo salió mal.';
}
