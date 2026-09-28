import 'package:flutter/material.dart';

/// QueueLock palette: deep greens + beige, with rosy brown as the single
/// warm accent. Calm clinical surfaces; green means go.
///
/// Rule: greens carry the interface; amber-green-red are reserved for
/// queue statuses, always paired with an icon and a label.
abstract final class AppTheme {
  // Brand greens.
  static const pine = Color(0xFF105666); // headers, navigation
  static const leaf = Color(0xFF0A3323); // primary actions (light)
  static const moss = Color(0xFF839958); // secondary surfaces, fills
  static const mossDeep = Color(0xFF5C7038); // moss text on light
  static const mossLight = Color(0xFFA9BE7F); // moss text on dark
  static const cream = Color(0xFFF7F4D5); // page background (light)
  static const ink = Color(0xFF223129); // main text (light)
  static const muted = Color(0xFF5A6B5E); // secondary text (light)
  static const border = Color(0xFFDCE3D2);

  // Dark surfaces derived from the same hues.
  static const darkBackground = Color(0xFF0B1A14);
  static const darkSurface = Color(0xFF10241B);
  static const darkCard = Color(0xFF143021);
  static const darkText = Color(0xFFE9F2E9);
  static const darkTextMuted = Color(0xFF9DB3A4);
  static const darkBorder = Color(0xFF1F3A2C);

  // The one warm accent: rosy brown, used sparingly (called glow).
  static const rose = Color(0xFFD3968C);

  // Aliases kept for call sites.
  static const waiting = moss;

  /// Status colors. Same hues both modes (dark values lifted for
  /// contrast). Never used without icon + label.
  static const ready = Color(0xFF2E9D68);
  static const readyDark = Color(0xFF3AB57E);
  static const issue = Color(0xFFD9534F);
  static const issueDark = Color(0xFFE57370);

  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: pine,
      onPrimary: Colors.white,
      secondary: leaf,
      onSecondary: cream,
      surface: cream,
      onSurface: ink,
      surfaceContainerHighest: Colors.white,
      onSurfaceVariant: muted,
      outlineVariant: border,
      error: issue,
    );
    return ThemeData(
      colorScheme: scheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: pine,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: cream,
      cardTheme: CardThemeData(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: leaf,
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
        fillColor: Colors.white,
      ),
    );
  }

  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: mossLight,
      onPrimary: leaf,
      secondary: mossLight,
      onSecondary: leaf,
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
        backgroundColor: pine,
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
          backgroundColor: cream,
          foregroundColor: leaf,
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
      'waiting' => dark ? mossLight : mossDeep,
      'called' || 'serving' => dark ? readyDark : ready,
      'skipped' || 'cancelled' => dark ? issueDark : issue,
      _ => dark ? darkTextMuted : muted,
    };
  }
}
