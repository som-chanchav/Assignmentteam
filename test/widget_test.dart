import 'package:flutter_test/flutter_test.dart';
import 'package:assignmentteam/View/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('OnboardingScreen renders initial screen properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    // Verify first screen Khmer titles
    expect(find.text('ស្វែងរក'), findsOneWidget);
    expect(find.text('ផ្ទះថ្មីរបស់អ្នក'), findsOneWidget);
    expect(find.text('បន្ទាប់'), findsOneWidget);
    expect(find.text('រំលង'), findsOneWidget);
  });
}
