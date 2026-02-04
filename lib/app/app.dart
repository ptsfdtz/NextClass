import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/local/hive_settings_repository.dart';
import '../data/models/app_settings.dart';
import 'home_shell.dart';
import 'routes.dart';
import 'theme.dart';

class TimetableApp extends StatelessWidget {
  const TimetableApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box<Map>('settings');
    final settingsRepository = HiveSettingsRepository();

    return ValueListenableBuilder<Box<Map>>(
      valueListenable: settingsBox.listenable(),
      builder: (context, value, child) {
        final settings = _readSettings(settingsRepository, value);
        return MaterialApp(
          title: 'NextClass',
          theme: AppTheme.light(preset: settings.themePreset),
          darkTheme: AppTheme.dark(preset: settings.themePreset),
          themeMode: _resolveThemeMode(settings.themeMode),
          initialRoute: AppRoutes.home,
          routes: {
            AppRoutes.home: (_) => const HomeShell(),
          },
        );
      },
    );
  }
}

AppSettings _readSettings(
  HiveSettingsRepository repository,
  Box<Map> box,
) {
  final map = box.get('app');
  final settings = AppSettings.fromMap(map);
  if (map == null) {
    repository.save(settings);
  }
  return settings;
}

ThemeMode _resolveThemeMode(String value) {
  switch (value) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}
