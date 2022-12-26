// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:riverpod_demo/app.dart';
import 'package:riverpod_demo/pages/extra_page.dart';
import 'package:riverpod_demo/pages/films_page.dart';
import 'package:riverpod_demo/pages/settings_page.dart';

void main() {
  testWidgets('Tap to star films test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    //Tap the star icon and trigger a frame.

    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();

    //Verify that star border icon was tapped and the color changed with new star icon.
    expect(find.byIcon(Icons.star).last, findsWidgets);
  });

  testWidgets('Clear button on textfield works properly',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    //navigating to extra page
    await tester.tap(find.byIcon(Icons.movie).first);
    await tester.pump();
    expect(find.byType(FilmsPage), findsOneWidget);
    //Verify that clear button on textfield wokrs properly
    await tester.enterText(find.byType(TextFormField), 'test');
    await tester.tap(find.byType(IconButton).first);
    final text = find.text(TextEditingController().text);
    expect(text, findsNothing);
  });

  testWidgets('Navigating bottom tab bars', (widgetTester) async {
    // Build our app and trigger a frame.
    await widgetTester.pumpWidget(const ProviderScope(child: MyApp()));

    //navigating to extra page
    await widgetTester.tap(find.byIcon(Icons.extension_rounded).first);
    await widgetTester.pump();
    //Verify that extra page is opened
    expect(find.byType(ExtraPage), findsOneWidget);
    await widgetTester.pumpAndSettle(const Duration(seconds: 1));
    //navigating to settings page
    await widgetTester.tap(find.byIcon(Icons.settings).first);
    await widgetTester.pump();
    //Verify that settings page is opened
    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('Data render in Extra Page', (widgetTester) async {
    // Build our app and trigger a frame.
    await widgetTester.pumpWidget(const ProviderScope(child: MyApp()));

    //navigating to extra page
    await widgetTester.tap(find.byIcon(Icons.extension_rounded).first);
    await widgetTester.pump();
    //Verify that extra page is opened
    expect(find.byType(ExtraPage), findsOneWidget);

    //Verify that extra page is loading to get data
    expect(find.byType(CircularProgressIndicator).first, findsOneWidget);
    await widgetTester.pumpAndSettle(const Duration(seconds: 1));
    //Verify that extra page is loaded data but API server does not active and not render with a ListView as expected
    expect(find.byType(ListView), findsNothing);
    //Verify after CircularProgressIndicator is done and TextButton 'Try again' will render.
    expect(find.byType(TextButton), findsOneWidget);
  });

  testWidgets('Show correct text in Settings Page', (widgetTester) async {
    // Build our app and trigger a frame.
    await widgetTester.pumpWidget(const ProviderScope(child: MyApp()));

    //navigating to settings page
    await widgetTester.tap(find.byIcon(Icons.settings).first);
    await widgetTester.pump();
    //Verify that settings page is opened
    expect(find.byType(SettingsPage), findsOneWidget);
    //Verify that there is correct text for theme
    expect(find.text('Theme Mode'), findsOneWidget);
  });

  testWidgets('Theme Mode is Light', (widgetTester) async {
    // Build our app and trigger a frame.
    await widgetTester.pumpWidget(const ProviderScope(child: MyApp()));

    final BuildContext context = widgetTester.element(find.byType(MaterialApp));
    final ThemeData theme = Theme.of(context);
    //Verify that theme mode is light
    expect(theme.brightness, Brightness.light);
  });
}
