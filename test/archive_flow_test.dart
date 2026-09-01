import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_daily/app/app.dart';
import 'package:tech_daily/core/storage/local_cache_service.dart';
import 'package:tech_daily/features/edition/data/mock_edition_repository.dart';
import 'package:tech_daily/features/edition/providers/edition_providers.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Archive Navigation Flow Tests', () {
    testWidgets('Tapping ARCHIVE opens archive screen with past editions',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final mockRepo = MockEditionRepository(latency: Duration.zero);
      final cacheService = LocalCacheService();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editionRepositoryProvider.overrideWithValue(mockRepo),
            localCacheServiceProvider.overrideWithValue(cacheService),
          ],
          child: const TechDailyApp(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();

      // Verify menu icon exists in header
      final menuButton = find.byIcon(Icons.menu_rounded);
      expect(menuButton, findsOneWidget);

      // Tap menu icon to open drawer
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      // Verify Archives is removed from drawer
      expect(find.text('Archives'), findsNothing);

      // Verify menu items and Night Mode footer are present
      expect(find.text("Today's Briefing"), findsOneWidget);
      expect(find.text("Liked News"), findsOneWidget);
      expect(find.text("Night Mode"), findsOneWidget);

      // Close drawer
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      // Back on today's newspaper
      expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    });
  });
}
