import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/view/home_page.dart';
import 'package:whatsapp_status_saver/util/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: AppTheme.darkTheme(),
      theme: AppTheme.lightTheme(),
      home: BlocProvider<HomePageBloc>(
          create: (context) => HomePageBloc(), child: const HomePage(),),
    );
  }
}
