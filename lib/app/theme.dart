import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light({required String preset}) {
    final palette = _palette(preset);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: palette.seed,
      brightness: Brightness.light,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: palette.background,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData dark({required String preset}) {
    final palette = _palette(preset);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: palette.seed,
      brightness: Brightness.dark,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: palette.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.darkBackground,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static _Palette _palette(String preset) {
    switch (preset) {
      case 'forest':
        return const _Palette(
          seed: Color(0xFF2A9D8F),
          background: Color(0xFFF3F7F5),
          darkBackground: Color(0xFF0F1D1B),
        );
      case 'sunset':
        return const _Palette(
          seed: Color(0xFFF25C54),
          background: Color(0xFFFFF4EF),
          darkBackground: Color(0xFF241514),
        );
      case 'ocean':
      default:
        return const _Palette(
          seed: Color(0xFF1F7AE0),
          background: Color(0xFFF6F7FB),
          darkBackground: Color(0xFF0F1624),
        );
    }
  }
}

class _Palette {
  const _Palette({
    required this.seed,
    required this.background,
    required this.darkBackground,
  });

  final Color seed;
  final Color background;
  final Color darkBackground;
}
