import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/view/home_page.dart';
import 'package:whatsapp_status_saver/util/app_data.dart';
import 'package:whatsapp_status_saver/util/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

StreamController<ThemeMode> themeModeController = StreamController<ThemeMode>();
var themeMode = ThemeMode.dark;
var currentType = WhatsappTypes.simple;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return const MainAppBody();
    });
  }
}

class MainAppBody extends StatelessWidget {
  const MainAppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeMode>(
        stream: themeModeController.stream,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Flutter Demo',
            themeMode: snapshot.data,
            darkTheme: AppTheme.darkTheme(),
            theme: AppTheme.lightTheme(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocProvider<HomePageBloc>(
              create: (context) {
                return HomePageBloc();
              },
              child: const HomePage(),
            ),
          );
        });
  }
}
