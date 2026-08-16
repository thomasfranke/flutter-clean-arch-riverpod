import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/failures/failures.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/domain/entities/preferences_entity.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/preferences/preferences_notifier.dart';
import 'package:flutter_clean_arch_riverpod/presentation/providers/preferences/preferences_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen for user preferences, allowing customization of
/// appearance and locale.
@RoutePage()
class PreferencesScreen extends ConsumerWidget {
  /// Creates a new instance of [PreferencesScreen].
  const PreferencesScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final PreferencesState state = ref.watch(preferencesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).settings)),
      body: switch (state) {
        PreferencesStateInitial() || PreferencesStateLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        PreferencesStateFailure(:final Failure failure) => Center(
          child: Text(failure.toString()),
        ),
        PreferencesStateSuccess(:final PreferencesEntity preferences) =>
          _PreferencesForm(preferences: preferences),
      },
    );
  }
}

class _PreferencesForm extends ConsumerWidget {
  const _PreferencesForm({required this.preferences});

  final PreferencesEntity preferences;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final PreferencesNotifier notifier = ref.read(preferencesProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        _SectionTitle(title: AppLocalizations.of(context).appearance),
        SwitchListTile(
          title: Text(AppLocalizations.of(context).darkMode),
          value: preferences.darkMode,
          onChanged: notifier.updateDarkMode,
        ),
        const Divider(),
        _SectionTitle(title: AppLocalizations.of(context).fontSize),
        Slider(
          value: preferences.fontScale,
          min: 0.8,
          max: 1.4,
          divisions: 6,
          label: preferences.fontScale.toStringAsFixed(1),
          onChanged: notifier.updateFontScale,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('A', style: TextStyle(fontSize: 12)),
            Text('A', style: TextStyle(fontSize: 20)),
          ],
        ),
        const Divider(),
        _SectionTitle(title: AppLocalizations.of(context).language),
        _LocaleTile(
          label: 'Português',
          value: 'pt',
          selected: preferences.locale,
          onTap: () => notifier.updateLocale('pt'),
        ),
        _LocaleTile(
          label: 'English',
          value: 'en',
          selected: preferences.locale,
          onTap: () => notifier.updateLocale('en'),
        ),
        _LocaleTile(
          label: 'Español',
          value: 'es',
          selected: preferences.locale,
          onTap: () => notifier.updateLocale('es'),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.grey,
      ),
    ),
  );
}

class _LocaleTile extends StatelessWidget {
  const _LocaleTile({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String value;
  final String selected;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) => ListTile(
    title: Text(label),
    trailing: selected == value
        ? const Icon(Icons.check, color: Colors.green)
        : null,
    onTap: onTap,
  );
}
