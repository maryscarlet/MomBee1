import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Primary & Secondary
  static const Color primary = Color(0xFFF80C51); // MomBee Signature Pink
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFFDADB);
  static const Color onPrimaryContainer = Color(0xFF40000E);
  static const Color primaryFixed = Color(0xFFFFDADB);
  static const Color primaryFixedDim = Color(0xFFFFB2B7);
  static const Color onPrimaryFixed = Color(0xFF40000E);
  static const Color onPrimaryFixedVariant = Color(0xFF91002B);

  static const Color secondary = Color(0xFFFECB16); // MomBee Signature Yellow
  static const Color onSecondary = Color(0xFF252525);
  static const Color secondaryContainer = Color(0xFFFFF1C2);
  static const Color onSecondaryContainer = Color(0xFF584400);
  static const Color secondaryFixed = Color(0xFFFFE08D);
  static const Color secondaryFixedDim = Color(0xFFF2C000);
  static const Color onSecondaryFixed = Color(0xFF241A00);
  static const Color onSecondaryFixedVariant = Color(0xFF584400);

  // Surfaces & Background
  static const Color background = Color(0xFFFFF9FA); // Soft background
  static const Color surface = Color(0xFFFFF9FA);
  static const Color surfaceDim = Color(0xFFEFE8E9);
  static const Color surfaceBright = Color(0xFFFFF9FA);
  static const Color surfaceVariant = Color(0xFFF8EEF0);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceContainerLow = Color(0xFFFFF5F6);
  static const Color surfaceContainer = Color(0xFFFDECEF);
  static const Color surfaceContainerHigh = Color(0xFFF9E4E7);
  static const Color surfaceContainerHighest = Color(0xFFF4DCE0);

  // Typography & UI
  static const Color onSurface = Color(0xFF252525); // Dark text
  static const Color onSurfaceVariant = Color(0xFF5A4A4D);
  static const Color outline = Color(0xFF9C878A);
  static const Color outlineVariant = Color(0xFFEAD2D6);
  static const Color borderCard = Color(0xFFF6E2E5);

  // Tertiary & Status
  static const Color tertiary = Color(0xFF5E5B5C);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF777475);
  static const Color tertiaryFixed = Color(0xFFE7E1E2);
  static const Color tertiaryFixedDim = Color(0xFFCAC5C6);
  static const Color onTertiaryFixedVariant = Color(0xFF494647);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0;
}

class AppShadows {
  static List<BoxShadow> naturalBloom = [
    const BoxShadow(
      color: Color.fromRGBO(248, 12, 81, 0.04),
      blurRadius: 16.0,
      offset: Offset(0, 4),
    ),
    const BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.02),
      blurRadius: 4.0,
      offset: Offset(0, 1),
    ),
  ];

  static List<BoxShadow> subtleCard = [
    const BoxShadow(
      color: Color.fromRGBO(248, 12, 81, 0.03),
      blurRadius: 12.0,
      offset: Offset(0, 2),
    ),
    const BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.02),
      blurRadius: 4.0,
      offset: Offset(0, 1),
    ),
  ];

  static List<BoxShadow> buttonElevation = [
    const BoxShadow(
      color: Color.fromRGBO(185, 0, 57, 0.25),
      blurRadius: 12.0,
      offset: Offset(0, 4),
    ),
  ];
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.notoSansBengali(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.33,
          color: AppColors.onSurface,
        ),
        headlineMedium: GoogleFonts.notoSansBengali(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.4,
          color: AppColors.onSurface,
        ),
        titleMedium: GoogleFonts.notoSansBengali(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: AppColors.onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: AppColors.onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.02,
          color: AppColors.onSurface,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceVariant,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
