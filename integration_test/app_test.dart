import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:secret_diary/main.dart';
import 'package:secret_diary/screens/splash_screen.dart';
import 'package:secret_diary/screens/pin_screen.dart';
import 'package:secret_diary/screens/set_pin_page.dart';
import 'package:secret_diary/screens/home_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('App UI Flow Test', () {
    testWidgets('Splash screen navigates to SetPinPage if no PIN is set', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({}); // Clear all prefs

      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(seconds: 2)); // wait for splash

      expect(find.byType(SplashScreen), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(SetPinPage), findsOneWidget);
    });

    testWidgets('Splash screen navigates to PinScreen if PIN is set', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'pin': '1234'});

      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(SplashScreen), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(PinScreen), findsOneWidget);
    });

    testWidgets('Correct PIN navigates to HomePage', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'pin': '1234'});

      await tester.pumpWidget(const MaterialApp(home: PinScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(PinScreen), findsOneWidget);
      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Incorrect PIN shows error text', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'pin': '1234'});

      await tester.pumpWidget(const MaterialApp(home: PinScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '9999');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('PIN salah, coba lagi'), findsOneWidget);
    });
  });
}
