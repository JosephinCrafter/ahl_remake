import 'package:flutter/material.dart';

class AhlTheme {
  AhlTheme._();

  static const Color greenOlive = Color(0xFF728C6D);
  static const Color yellowRelax = Color(0xFFFFD166);
  static const Color yellowLight = Color(0xFFFFF9E6);
  static const Color blackCharcoal = Color(0xFF282828);
  static const Color blueNight = Color(0xFF36454F);
  static const Color darkNight = Color(0xFF1A202C);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: greenOlive,
      secondary: yellowRelax,
      // secondaryContainer: yellowLight,
      background: yellowLight,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    textTheme: textTheme,
    useMaterial3: true,
  );

  static const Color primaryColor = Color(0xFF007bff);
  static const Color onPrimaryColor = Color(0xFFFFFFFF);
  static const Color secondaryColor = Color(0xFF673ab7);
  static const Color onSecondaryColor = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF000000);
  static const Color surface = Color(0xFFF2F2F2);
  static const Color onSurface = Color(0xFF212121);
  static const Color error = Color(0xFFF44336);
  static const Color onError = Color(0xFFFFFFFF);

  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Butler',
    fontSize: 57,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: -0.5,
    color: onBackground,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Butler',
    fontSize: 45,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: -0.25,
    color: onBackground,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: 'Butler',
    fontSize: 36,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    color: onBackground,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Butler',
    fontSize: 30,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.15,
    color: onBackground,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Butler',
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.2,
    color: onBackground,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'Butler',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.15,
    color: onBackground,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Aileron',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.1,
    color: onBackground,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Aileron',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.1,
    color: onBackground,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: 'Aileron',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.05,
    color: onBackground,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Aileron',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.5,
    color: onBackground,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Aileron',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.25,
    color: onBackground,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Aileron',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0.25,
    color: onBackground,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Aileron',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    color: onSurface,
  );

  static const TextStyle name = TextStyle(
    fontFamily: 'Aileron',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    letterSpacing: 0,
    color: onSurface,
  );

  static const TextStyle peopleTitle = TextStyle(
    fontFamily: 'Aileron',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    letterSpacing: 0,
    color: Color(0xFF4d4d4d),
  );

  // static TextTheme textTheme = Typography.material2021().copyWith();

  static TextTheme get textTheme => Typography.blackMountainView.copyWith(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineSmall: headlineSmall,
        headlineMedium: headlineMedium,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        // labelLarge: label,
      );
}
