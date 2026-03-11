import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:crop_disease_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End App Test', () {
    testWidgets('Guest Login and Navigation Flow', (tester) async {
      // 1. Launch the app
      app.main();
      await tester.pumpAndSettle();

      // 2. Click "Continue as Guest"
      final guestButton = find.text('Continue as Guest');
      expect(guestButton, findsOneWidget);
      
      await tester.tap(guestButton);
      await tester.pumpAndSettle();

      // 3. Verify we reached the Main Navigation (Home)
      // MainNavigation typically has a BottomNavigationBar
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      
      // 4. Navigate to Settings
      final settingsIcon = find.byIcon(Icons.settings);
      if (settingsIcon.evaluate().isNotEmpty) {
        await tester.tap(settingsIcon);
        await tester.pumpAndSettle();
        expect(find.text('Settings'), findsWidgets);
      }
    });
  });
}
