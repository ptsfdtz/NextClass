import 'package:flutter/material.dart';

import 'home_shell.dart';
import 'routes.dart';
import 'theme.dart';

class TimetableApp extends StatelessWidget {
  const TimetableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timetable',
      theme: AppTheme.light(),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const HomeShell(),
      },
    );
  }
}
