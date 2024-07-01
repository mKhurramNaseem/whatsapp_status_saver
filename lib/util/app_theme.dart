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
      scaffoldBackgroundColor: AppColor.whiteColor,
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColor.whiteColor,
      ),
      brightness: Brightness.light,
      listTileTheme: const ListTileThemeData(
        textColor: AppColor.blackColor,
        iconColor: AppColor.blackColor,
      ),
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Colors.white));
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
      scaffoldBackgroundColor: AppColor.blackColor,
      navigationDrawerTheme: const NavigationDrawerThemeData(
        backgroundColor: AppColor.blackColor,
        iconTheme:
            WidgetStatePropertyAll(IconThemeData(color: AppColor.whiteColor)),
        labelTextStyle:
            WidgetStatePropertyAll(TextStyle(color: AppColor.whiteColor)),
      ),
      brightness: Brightness.light,
      listTileTheme: const ListTileThemeData(
        textColor: AppColor.whiteColor,
        iconColor: AppColor.whiteColor,
      ),
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: AppColor.blackColor));
}

class AppColor {
  static const greenColor = Color(0xff128c7e);
  static const whiteColor = Colors.white;
  static const greyColor = Colors.grey;
  static const blackColor = Colors.black54;
}
