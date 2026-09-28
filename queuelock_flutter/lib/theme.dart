import 'package:flutter/material.dart';

/// QueueLock palette: cherry matcha — deep maroon + fresh matcha on warm
/// cream. Maroon carries headers and actions; matcha carries highlights;
/// rosy brown is the single warm accent.
///
/// Rule: maroon and matcha carry the interface; amber-green-red are
/// reserved for queue statuses, always paired with an icon and a label.
abstract final class AppTheme {
  // Brand.
  static const maroon = Color(0xFF670626); // headers, actions (light)
  static const maroonDeep = Color(0xFF4A0419);
  static const matcha = Color(0xFFBAD797); // highlights, fills
  static const matchaDeep = Color(0xFF5F7E33); // matcha text on light
  static const matchaLight = Color(0xFFCFE3A8); // matcha text on dark
  static const cream = Color(0xFFFAF3E7); // page background (light)
  static const paper = Color(0xFFFFFDF8); // cards (light)
  static const ink = Color(0xFF2E1B1E); // main text (light)
  static const muted = Color(0xFF8A6F6B); // secondary text (light)
  static const border = Color(0xFFEADFCB);

  // Dark surfaces derived from the same family.
  static const darkBackground = Color(0xFF150A0E);
  static const darkSurface = Color(0xFF1F1016);
  static const darkCard = Color(0xFF2A1420);
  static const darkText = Color(0xFFF5E9E4);
  static const darkTextMuted = Color(0xFFC4A5A0);
  static const darkBorder = Color(0xFF3A2230);

  // The one warm accent: rosy brown, used sparingly (glow, QR edge).
  static const rose = Color(0xFFD3968C);

  // Aliases kept for call sites.
  static const waiting = matcha;

  /// Status colors. Same hues both modes (dark values lifted for
  /// contrast). Never used without icon + label.
  static const ready = Color(0xFF2E7D4F);
  static const readyDark = Color(0xFF43B581);
  static const issue = Color(0xFFC0392B);
  static const issueDark = Color(0xFFE57370);

  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: maroon,
      onPrimary: Colors.white,
      secondary: matchaDeep,
      onSecondary: Colors.white,
      surface: cream,
      onSurface: ink,
      surfaceContainerHighest: paper,
      onSurfaceVariant: muted,
      outlineVariant: border,
      error: issue,
    );
    return ThemeData(
      colorScheme: scheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: maroon,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: cream,
      cardTheme: CardThemeData(
        color: paper,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: maroon,
          foregroundColor: cream,
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: paper,
      ),
    );
  }

  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: matchaLight,
      onPrimary: maroonDeep,
      secondary: matchaLight,
      onSecondary: maroonDeep,
      surface: darkBackground,
      onSurface: darkText,
      surfaceContainerHighest: darkCard,
      onSurfaceVariant: darkTextMuted,
      outlineVariant: darkBorder,
      error: issueDark,
    );
    return ThemeData(
      colorScheme: scheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: maroon,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: darkBackground,
      cardTheme: CardThemeData(
        color: darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: darkBorder),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: matcha,
          foregroundColor: maroonDeep,
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }

  /// Status color for a ticket state. Never used without icon + label.
  static Color statusColor(String statusName, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (statusName) {
      'waiting' => dark ? matchaLight : matchaDeep,
      'called' || 'serving' => dark ? readyDark : ready,
      'skipped' || 'cancelled' => dark ? issueDark : issue,
      _ => dark ? darkTextMuted : muted,
    };
  }
}
