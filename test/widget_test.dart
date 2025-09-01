// BlitzNow Training App Widget Tests
//
// Tests for the BlitzNow Training Flutter app functionality.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:blitznow_training_flutter/main.dart';
import 'package:blitznow_training_flutter/providers/training_provider.dart';

void main() {
  testWidgets('BlitzNow Training App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads with the welcome screen
    expect(find.text('BlitzNow'), findsOneWidget);
    expect(find.text('Training Portal'), findsOneWidget);
    expect(find.text('Welcome to BlitzNow Family! 🚀'), findsOneWidget);
    
    // Verify that the rider ID input field is present
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Rider ID'), findsOneWidget);
    
    // Verify that the start training button is present
    expect(find.text('Start Training'), findsOneWidget);
  });

  testWidgets('Rider ID input validation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Find the text field and enter empty text
    final textField = find.byType(TextFormField);
    await tester.enterText(textField, '');
    
    // Find and tap the submit button
    final submitButton = find.text('Start Training');
    await tester.tap(submitButton);
    await tester.pump();

    // Verify validation error appears
    expect(find.text('Please enter your Rider ID'), findsOneWidget);
  });

  testWidgets('Rider ID input with valid data test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Find the text field and enter valid rider ID
    final textField = find.byType(TextFormField);
    await tester.enterText(textField, 'TEST_RIDER_123');
    
    // Verify the text was entered
    expect(find.text('TEST_RIDER_123'), findsOneWidget);
  });

  testWidgets('App theme and styling test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app uses the correct theme colors
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.colorScheme.primary, isNotNull);
    
    // Verify that the delivery icon is present
    expect(find.byIcon(Icons.delivery_dining), findsOneWidget);
  });
}
