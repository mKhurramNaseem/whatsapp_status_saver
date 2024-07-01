import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_events.dart';
import 'package:whatsapp_status_saver/main.dart';
import 'package:whatsapp_status_saver/util/app_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  static const _simpleWhatsapp = 'Whatsapp',
      _businessWhatsapp = 'Business Whatsapp';
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomePageBloc>();
    return NavigationDrawer(
      children: [
        DrawerHeader(
          child: Image.asset(AppData.logo),
        ),
        StatefulBuilder(builder: (context, setState) {
          return ListTile(
            leading: Icon(currentType == WhatsappTypes.simple
                ? Icons.business
                : FontAwesomeIcons.whatsapp),
            title: Text(currentType == WhatsappTypes.simple
                ? AppLocalizations.of(context)?.businessWhatsapp ??
                    _businessWhatsapp
                : AppLocalizations.of(context)?.whatsapp ?? _simpleWhatsapp),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              setState(
                () {
                  if (currentType == WhatsappTypes.simple) {
                    currentType = WhatsappTypes.business;
                  } else {
                    currentType = WhatsappTypes.simple;
                  }
                  bloc.add(HomePageInitialEvent());
                },
              );
            },
          );
        }),
        StatefulBuilder(builder: (context, setState) {
          return ListTile(
            leading: themeMode == ThemeMode.light
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.light_mode),
            title: Text(themeMode == ThemeMode.light
                ? AppLocalizations.of(context)?.darkMode ?? "Dark Mode"
                : AppLocalizations.of(context)?.lightMode ?? 'Light Mode'),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              setState(
                () {
                  if (themeMode == ThemeMode.light) {
                    themeMode = ThemeMode.dark;
                    themeModeController.add(ThemeMode.dark);
                  } else {
                    themeMode = ThemeMode.light;
                    themeModeController.add(ThemeMode.light);
                  }
                },
              );
            },
          );
        }),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: Text(
              AppLocalizations.of(context)?.privacyPolicy ?? 'Privacy Policy'),
        ),
        ListTile(
          leading: const Icon(Icons.document_scanner),
          title: Text(AppLocalizations.of(context)?.termsAndConditions ??
              'Terms & Conditions'),
        ),
        ListTile(
          leading: const Icon(Icons.star),
          title: Text(AppLocalizations.of(context)?.rateUs ?? 'Rate Us'),
        ),
      ],
    );
  }
}
