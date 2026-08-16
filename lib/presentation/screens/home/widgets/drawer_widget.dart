import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch_riverpod/core/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_arch_riverpod/core/routes/auto_route.dart';

/// Drawer widget for the home screen, providing navigation options.
class AppDrawer extends StatelessWidget {
  /// Creates a new instance of [AppDrawer].
  const AppDrawer({super.key});

  @override
  Widget build(final BuildContext context) => Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.currency_bitcoin, size: 40, color: Colors.white),
              SizedBox(height: 8),
              Text(
                'Crypto Quotes',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(AppLocalizations.of(context).settings),
          onTap: () async => context.router.push(const PreferencesRoute()),
        ),
      ],
    ),
  );
}
