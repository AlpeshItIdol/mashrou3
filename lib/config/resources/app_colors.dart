import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color pageBackground = Color(0xFFFFFFFF);
  static const Color colorSecondaryShade = Color(0xFF6DA8A6);
  static const Color colorSecondary = Color(0xFF457E83);
  static const Color colorPrimary = Color(0xFF3E7177);
  static Color get colorPrimaryShade => colorPrimary.withOpacity(0.1);
  static const Color colorPrimaryIceShade = Color(0xFFAED7D8);
  static const Color colorLightPrimary = Color(0xFFF3FEFF);
  static const Color colorBottomNavPrimary = Color.fromRGBO(52, 114, 120, 0.15);
  static const Color colorBgPrimary = Color.fromRGBO(52, 114, 120, 0.1);
  static const Color deleteIconColor = Color(0xFFC50F0F);
  static const Color boxShadow = Color(0x1a404f68);
  static const Color white = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFBA1A1A);
  static const Color red00 = Color(0xFFD50000);
  static const Color red33 = Color(0xFFBF3333);

  // Black shade
  static const Color black = Color(0xFF000000);
  static const Color black11 = Color(0xFF111111);
  static const Color black22 = Color(0xFF222222);
  static const Color black2E = Color(0xFF2E2E2E);
  static const Color black3D = Color(0xFF3D3D3D);
  static const Color black5E = Color(0xFF5E5E5E);
  static const Color black48 = Color(0xFF484848);
  static const Color black20 = Color(0xFF1D1B20);
  static const Color black14 = Color(0xFF141414);
  static const Color black34 = Color(0xFF141B34);
  static const Color blackOp14 = Color(0x99141414);

  // Grey shade
  static const Color greyE8 = Color(0xFFE8E8E8);
  static const Color grey8A = Color(0xFF8A8A8A);
  static const Color grey77 = Color(0xFF6B7177);
  static const Color greyE9 = Color(0xFFD2DADA);
  static const Color greyF5 = Color(0xFFF5F5F5);
  static const Color greyF8 = Color(0xFFF5F4F8);
  static const Color greyFA = Color(0xFFFAFAFA);
  static const Color greyF5F4 = Color(0xFFF5F4F8);
  static const Color greyF1 = Color(0xFFF1F1F1);
  static const Color grey88 = Color(0xFF888888);
  static const Color grey50 = Color(0xFF505050);
  static const Color greyB0 = Color(0xFFA5A8B0);

  // Gold shade
  static const Color goldA1 = Color(0xFFE7D1A1);

  /// Gradient Colors
  static LinearGradient primaryGradient = const LinearGradient(
    begin: Alignment(-3.50, -4),
    end: Alignment(1, 0),
    colors: [
      Color(0xFFE6E1D6), // #E6E1D6
      Color(0xFF044247), // #044247
    ],
  );

  static const LinearGradient greyGradient = LinearGradient(
    colors: [
      Color(0xFF6B7177), // Original color
      Color(0xFF898F94), // Slightly lighter shade
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF296267),
    onPrimary: Color(0xFFFFFFFF),
    // primaryContainer: Color(0xFFD6D5F4),
    onPrimaryContainer: Color(0xFF121214),
    secondary: Color(0xFF347278),
    onSecondary: Color(0xFFFFFFFF),
    // secondaryContainer: Color(0xFFC0BFF6),
    onSecondaryContainer: Color(0xFF101014),
    // tertiary: Color(0xFF6F6DF6),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFEBEBFD),
    onTertiaryContainer: Color(0xFF141414),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFAF9FD),
    onBackground: Color(0xFF090909),
    surface: Color(0xFFFAF9FD),
    onSurface: Color(0xFF090909),
    surfaceVariant: Color(0xFFE4E4EC),
    onSurfaceVariant: Color(0xFF111112),
    outline: Color(0xFF7C7C7C),
    outlineVariant: Color(0xFFC8C8C8),
    onInverseSurface: Color(0xFFF5F5F5),
    inverseSurface: Color(0xFF121216),
    inversePrimary: Color(0xFFFFFFFF),
    surfaceTint: Color(0xFF4947D0),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );
}
