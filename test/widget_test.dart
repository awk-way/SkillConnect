// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skillconnect/main.dart';

void main() {
  testWidgets('SkillConnect App loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(SkillConnectApp());

    // Verify that our app title appears
    expect(find.text('SkillConnect'), findsOneWidget);

    // Verify that location text appears
    expect(find.text('Your Location'), findsOneWidget);

    // Verify that service categories section appears
    expect(find.text('Service Categories'), findsOneWidget);

    // Verify that quick actions section appears
    expect(find.text('Quick Actions'), findsOneWidget);

    // Verify that Post a Job button exists
    expect(find.text('Post a Job'), findsOneWidget);
  });
}
