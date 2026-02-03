// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:next_class/app/app.dart';

void main() {
  setUpAll(() async {
    final directory = await Directory.systemTemp.createTemp();
    Hive.init(directory.path);
    await Hive.openBox<Map>('courses');
    await Hive.openBox<Map>('settings');
  });

  tearDownAll(() async {
    await Hive.close();
  });

  testWidgets('App shell renders timetable screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TimetableApp());
    await tester.pumpAndSettle();

    expect(find.text('周一'), findsOneWidget);
    expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
