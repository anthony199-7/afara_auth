import 'package:flutter/material.dart';

/// App theme and sizing constants for consistent UI across the application
class AppTheme {
  // Color scheme
  static const Color primaryColor = Color(0xFF1E3A8A);
  static const Color secondaryColor = Color(0xFF3B82F6);
  static const Color accentColor = Color(0xFF10B981);

  // Spacing constants
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 18.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border radius
  static const double borderRadiusSM = 4.0;
  static const double borderRadiusMD = 8.0;
  static const double borderRadiusLG = 12.0;
  static const double borderRadiusXL = 16.0;

  // Font sizes
  static const double fontSizeXS = 12.0;
  static const double fontSizeSM = 14.0;
  static const double fontSizeMD = 16.0;
  static const double fontSizeLG = 18.0;
  static const double fontSizeXL = 20.0;
  static const double fontSizeXXL = 24.0;
  static const double fontSizeXXXL = 32.0;

  // Component sizes
  static const double cardWidth = 260.0;
  static const double cardHeight = 306.0;
  static const double headerHeight = 555.0;
  static const double toggleSelectorWidth = 522.0;

  // Breakpoints for responsive design
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  /// Get responsive padding based on screen width
  static EdgeInsets responsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return const EdgeInsets.all(spacingMD);
    } else if (width < tabletBreakpoint) {
      return const EdgeInsets.all(spacingLG);
    } else {
      return const EdgeInsets.all(spacingXL);
    }
  }

  /// Get responsive max width for containers
  static double responsiveMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return width * 0.9;
    } else if (width < tabletBreakpoint) {
      return width * 0.92;
    } else {
      return 1100.0;
    }
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  /// Get responsive page max width for top-level content
  static double responsivePageWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return width * 0.95;
    } else if (width < tabletBreakpoint) {
      return width * 0.95;
    } else {
      return 1200.0;
    }
  }

  /// Get responsive card dimensions
  static Size responsiveCardSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return const Size(200.0, 250.0);
    } else if (width < tabletBreakpoint) {
      return const Size(220.0, 280.0);
    } else {
      return const Size(cardWidth, cardHeight);
    }
  }

  /// Get responsive header height
  static double responsiveHeaderHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 400.0;
    } else if (width < tabletBreakpoint) {
      return 400.0;
    } else {
      return headerHeight;
    }
  }

  /// Get responsive toggle selector width
  static double responsiveToggleSelectorWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return width * 0.8;
    } else if (width < tabletBreakpoint) {
      return 400.0;
    } else {
      return toggleSelectorWidth;
    }
  }

  /// Get responsive hub container width
  static double responsiveHubWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return width * 0.9;
    } else if (width < tabletBreakpoint) {
      return 500.0;
    } else {
      return 606.0;
    }
  }

  /// Create the app's ThemeData
  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: fontSizeXXXL,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        displayMedium: TextStyle(
          fontSize: fontSizeXXL,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        bodyLarge: TextStyle(fontSize: fontSizeMD, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: fontSizeSM, color: Colors.black54),
        bodySmall: TextStyle(fontSize: fontSizeXS, color: Colors.black54),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusMD)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLG,
            vertical: spacingMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMD),
          ),
        ),
      ),
    );
  }
}
