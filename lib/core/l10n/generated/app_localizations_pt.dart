// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get quotes => 'Cotações';

  @override
  String get settings => 'Configurações';

  @override
  String get darkMode => 'Modo Escuro';

  @override
  String get fontSize => 'Tamanho de Fonte';

  @override
  String get favorites => 'Favoritos';

  @override
  String get filterBySymbol => 'Filtrar por Símbolo';

  @override
  String get language => 'Idioma';

  @override
  String get lastPrice => 'Último Preço';

  @override
  String get priceChange24h => 'Variação 24h';

  @override
  String get absoluteChange => 'Variação Absoluta';

  @override
  String get high24h => 'Máxima 24h';

  @override
  String get low24h => 'Mínima 24h';

  @override
  String get baseVolume => 'Volume Base';

  @override
  String get quoteVolume => 'Volume Quote';

  @override
  String get appearance => 'Aparência';

  @override
  String get priceHistory => 'Histórico de Preço';

  @override
  String get noFavoritesYet => 'Nenhum favorito ainda';

  @override
  String get noData => 'Sem dados';

  @override
  String get failureNetwork =>
      'Sem conexão. Verifique sua internet e tente de novo.';

  @override
  String get failureServer =>
      'O servidor está com problemas. Tente de novo em instantes.';

  @override
  String get failureNotFound => 'Nada foi encontrado para esta busca.';

  @override
  String get failureClient => 'A requisição foi recusada.';

  @override
  String get failureParse => 'Não foi possível ler os dados recebidos.';

  @override
  String get failureStorage =>
      'Não foi possível acessar os dados salvos neste aparelho.';

  @override
  String get failureUnexpected => 'Algo deu errado.';
}
