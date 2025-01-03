import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wellnesspath/main.dart';
import 'package:wellnesspath/pages/login_page.dart';
import 'package:wellnesspath/pages/home_page.dart';

void main() {
  // Test the MyApp widget when the user is not logged in
  testWidgets('MyApp shows LoginPage when not logged in', (WidgetTester tester) async {
    // Pump the MyApp widget with `isLoggedIn` set to false
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    // Verify that the LoginPage is displayed
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Login'), findsOneWidget); // Assumes LoginPage has "Login" text
  });

  // Test the MyApp widget when the user is logged in
  testWidgets('MyApp shows HomePage when logged in', (WidgetTester tester) async {
    // Pump the MyApp widget with `isLoggedIn` set to true
    await tester.pumpWidget(const MyApp(isLoggedIn: true));

    // Verify that the HomePage is displayed
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Home'), findsOneWidget); // Assumes HomePage has "Home" text
  });

  // Test navigation from LoginPage to HomePage
  testWidgets('LoginPage navigates to HomePage on successful login', (WidgetTester tester) async {
    // Pump the LoginPage widget
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
        routes: {
          '/home': (context) => const HomePage(),
        },
      ),
    );

    // Verify LoginPage is shown initially
    expect(find.byType(LoginPage), findsOneWidget);

    // Enter username and password
    await tester.enterText(find.byType(TextField).first, 'testuser'); // Username
    await tester.enterText(find.byType(TextField).last, 'password123'); // Password

    // Tap the login button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify HomePage is shown after login
    expect(find.byType(HomePage), findsOneWidget);
  });
}
