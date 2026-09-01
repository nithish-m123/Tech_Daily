import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_daily/app/app.dart';
import 'package:tech_daily/core/storage/local_cache_service.dart';
import 'package:tech_daily/features/edition/data/mock_edition_repository.dart';
import 'package:tech_daily/features/edition/presentation/widgets/biggest_story_card.dart';
import 'package:tech_daily/features/edition/providers/edition_providers.dart';
import 'package:tech_daily/features/story/domain/source.dart';
import 'package:tech_daily/features/story/domain/story.dart';
import 'package:tech_daily/features/story/presentation/widgets/story_card.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('StoryCard Widget Tests', () {
    testWidgets('Renders all required sections and key points', (tester) async {
      final testStory = Story(
        id: 'test_1',
        category: 'DEVELOPERS',
        headline: 'Major Flutter Engine Architecture Overhaul',
        summary: 'The graphics pipeline has been refactored for lower frame latency.',
        whyItMatters: 'Complex scroll views render with zero frame drops.',
        keyPoints: const ['Point Alpha', 'Point Beta'],
        publishedAt: DateTime(2026, 9, 1),
        sources: const [
          Source(name: 'Flutter Dev', url: 'https://flutter.dev'),
          Source(name: 'GitHub', url: 'https://github.com'),
        ],
        estimatedReadMinutes: 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: StoryCard(story: testStory),
            ),
          ),
        ),
      );

      // Verify category tag & reading time
      expect(find.text('DEVELOPERS'), findsOneWidget);
      expect(find.text('2 min read'), findsOneWidget);

      // Verify headline
      expect(find.text('Major Flutter Engine Architecture Overhaul'), findsOneWidget);

      // Verify section titles
      expect(find.text('WHAT HAPPENED'), findsOneWidget);
      expect(find.text(testStory.summary), findsOneWidget);

      expect(find.text('WHY IT MATTERS'), findsOneWidget);
      expect(find.text(testStory.whyItMatters), findsOneWidget);

      expect(find.text('KEY POINTS'), findsOneWidget);
      expect(find.text('Point Alpha'), findsOneWidget);
      expect(find.text('Point Beta'), findsOneWidget);

      // Verify sources and Read Original action
      expect(find.text('Flutter Dev'), findsOneWidget);
      expect(find.text('GitHub'), findsOneWidget);
      expect(find.text('READ ORIGINAL'), findsOneWidget);
    });

    testWidgets('BiggestStoryCard renders hero badge and details', (tester) async {
      final heroStory = Story(
        id: 'hero_test',
        category: 'AI & MACHINE LEARNING',
        headline: 'Frontier AI Agents Automate Complex Tasks',
        summary: 'Reasoning models now execute deterministic sandboxed operations.',
        whyItMatters: 'Allows reliable automation in high-stakes fields.',
        keyPoints: const ['Verified logic trees'],
        publishedAt: DateTime(2026, 9, 1),
        sources: const [Source(name: 'Reuters', url: 'https://reuters.com')],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BiggestStoryCard(story: heroStory),
            ),
          ),
        ),
      );

      expect(find.text("TODAY'S BIGGEST STORY"), findsOneWidget);
      expect(find.text('Frontier AI Agents Automate Complex Tasks'), findsOneWidget);
      expect(find.text('READ ORIGINAL'), findsOneWidget);
    });
  });

  group('TechDailyApp Paginated Reader Flow Test', () {
    testWidgets('App opens to Cover page and navigates through pages with swipe and buttons',
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

      // Pump to trigger build, microtask, and async data completion
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();

      // Masthead brand and subtitle on Cover page
      expect(find.text('TECH DAILY'), findsWidgets);
      expect(find.text("TODAY'S TECHNOLOGY BRIEFING"), findsOneWidget);

      // Check for hero card on Cover page
      expect(find.text("TODAY'S BIGGEST STORY"), findsOneWidget);

      // Check for navigation menu icon in header
      expect(find.byIcon(Icons.menu_rounded), findsOneWidget);

      // Verify search icon is not present
      expect(find.byIcon(Icons.search), findsNothing);
      expect(find.byIcon(Icons.search_rounded), findsNothing);

      // Check bottom navigation buttons
      expect(find.text('START'), findsOneWidget);

      // Tap NEXT / START to go to Hot Topic page
      await tester.tap(find.text('START'));
      await tester.pumpAndSettle();

      // Now on What's Hot Today page
      expect(find.text("WHAT'S HOT TODAY?"), findsOneWidget);
      expect(find.text('HOT TOPIC'), findsOneWidget);

      // Tap NEXT to go to first story page
      await tester.tap(find.text('NEXT'));
      await tester.pumpAndSettle();

      // Now on Story 1 page
      expect(find.textContaining('STORY 1 OF'), findsOneWidget);
      expect(find.text('WHAT HAPPENED'), findsOneWidget);
      expect(find.text('WHY IT MATTERS'), findsOneWidget);

      // Tap PREV to go back to Hot Topic
      await tester.tap(find.text('PREV'));
      await tester.pumpAndSettle();

      expect(find.text("WHAT'S HOT TODAY?"), findsOneWidget);
    });
  });
}
