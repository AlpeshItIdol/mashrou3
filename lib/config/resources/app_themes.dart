import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mashrou3/config/resources/text_styles.dart';

import 'app_colors.dart';

class AppThemes {
  static ThemeData main({
    bool isDark = false,
  }) {
    return ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primaryColor: isDark ? AppColors.white : AppColors.black14,
        scaffoldBackgroundColor: isDark ? AppColors.black14 : AppColors.white,
        cardColor: isDark ? AppColors.black14 : AppColors.white,
        canvasColor: isDark ? AppColors.black14 : AppColors.white,
        highlightColor: isDark ? AppColors.white : AppColors.colorPrimary,
        disabledColor:
            isDark ? AppColors.colorPrimary : AppColors.colorBgPrimary,
        focusColor: isDark ? AppColors.white : AppColors.black,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.white : AppColors.black,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: isDark ? AppColors.black14 : AppColors.white,
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 86,
          indicatorColor:
              isDark ? AppColors.colorPrimary : AppColors.colorBottomNavPrimary,
          backgroundColor: isDark ? AppColors.black14 : AppColors.white,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) {
              return h14(
                fontWeight: FontWeight.w500,
                color: states.contains(WidgetState.selected)
                    ? AppColors.colorPrimary
                    : isDark
                        ? AppColors.white
                        : AppColors.black14,
              );
            },
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: isDark ? AppColors.black14 : AppColors.white,
          systemOverlayStyle: isDark
              ? const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: Colors.black,
                  statusBarBrightness: Brightness.dark,
                  statusBarIconBrightness: Brightness.light,
                  systemNavigationBarIconBrightness: Brightness.light,
                )
              : const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: Colors.white,
                  statusBarBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.dark,
                  systemNavigationBarIconBrightness: Brightness.dark,
                ),
        ),
        dialogBackgroundColor: isDark ? AppColors.black14 : AppColors.white,
        hoverColor: isDark ? AppColors.white : AppColors.black3D,
        switchTheme: SwitchThemeData(
          trackColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.colorPrimary;
            }
            return AppColors.greyE8;
          }),
          trackOutlineColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.transparent;
            }
            return Colors.transparent;
          }),
          trackOutlineWidth: WidgetStateProperty.resolveWith<double>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return 0;
            }
            return 0;
          }),
          thumbColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return isDark ? AppColors.black14 : AppColors.white;
            }
            return AppColors.white;
          }),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppColors.colorPrimary),
        drawerTheme: DrawerThemeData(),
        dividerColor: isDark ? AppColors.grey50 : AppColors.greyE8,
        textTheme: TextTheme(
          displaySmall:
              h18(color: isDark ? AppColors.white : AppColors.black14),
          headlineMedium:
              h24(color: isDark ? AppColors.white : AppColors.black14),
          headlineSmall:
              h24(color: isDark ? AppColors.white : AppColors.black14),
          bodySmall: h12(color: isDark ? AppColors.white : AppColors.black14),
          bodyMedium: h14(color: isDark ? AppColors.white : AppColors.black14),
          bodyLarge: h20(color: isDark ? AppColors.white : AppColors.black14),
          titleSmall: h14(color: isDark ? AppColors.white : AppColors.black14),
          titleMedium: h16(color: isDark ? AppColors.white : AppColors.black14),
          titleLarge: h18(color: isDark ? AppColors.white : AppColors.black14),
          labelSmall: h12(color: isDark ? AppColors.white : AppColors.black14),
          labelMedium: h16(color: isDark ? AppColors.white : AppColors.black14),
          labelLarge: h20(color: isDark ? AppColors.white : AppColors.black14),
        ),
        dialogTheme: DialogThemeData(backgroundColor: AppColors.white));
  }
}
