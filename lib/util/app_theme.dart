import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: AppColor.greenColor,
          secondary: Colors.white,
        ),
        tabBarTheme: TabBarTheme(
          indicatorColor: Colors.white,
          dividerColor: AppColor.greenColor,
          labelColor: AppColor.whiteColor,
          unselectedLabelColor: AppColor.whiteColor.withOpacity(0.8),
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.greenColor,
            foregroundColor: AppColor.whiteColor),
      );
  static ThemeData darkTheme() => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: AppColor.greenColor,
          secondary: Colors.white,
        ),
        tabBarTheme: TabBarTheme(
          indicatorColor: Colors.white,
          dividerColor: AppColor.greenColor,
          labelColor: AppColor.whiteColor,
          unselectedLabelColor: AppColor.whiteColor.withOpacity(0.8),
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.greenColor,
            foregroundColor: AppColor.whiteColor),
      );
}

class AppColor {
  static const greenColor = Color(0xff128c7e);
  static const whiteColor = Colors.white;
  static const greyColor = Colors.grey;
}
