import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_daily/app/app.dart';
import 'package:tech_daily/core/storage/local_cache_service.dart';
import 'package:tech_daily/features/edition/data/edition_repository.dart';
import 'package:tech_daily/features/edition/data/mock_edition_repository.dart';
import 'package:tech_daily/features/edition/domain/edition.dart';
import 'package:tech_daily/features/edition/providers/edition_providers.dart';

class FailingEditionRepository implements EditionRepository {
  @override
  Future<Edition> getTodayEdition() async {
    throw Exception('Simulated network error');
  }

  @override
  Future<Edition> getEdition(DateTime date) async {
    throw Exception('Simulated network error');
  }

  @override
  Future<List<DateTime>> getArchiveDates() async {
    throw Exception('Simulated network error');
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Offline Fallback & Error State Tests', () {
    testWidgets('Shows error state with RETRY button when no cache exists and network fails',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editionRepositoryProvider.overrideWithValue(FailingEditionRepository()),
          ],
          child: const TechDailyApp(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Error message should be visible
      expect(find.textContaining('Unable to load today\'s edition'), findsOneWidget);
      expect(find.text('RETRY'), findsOneWidget);
    });

    testWidgets('Shows cached edition with offline notice when network fails but cache exists',
        (tester) async {
      final cacheService = LocalCacheService();
      final mockRepo = MockEditionRepository(latency: Duration.zero);
      final sampleEdition = await mockRepo.getTodayEdition();

      // Pre-populate cache
      await cacheService.saveLatestEdition(sampleEdition);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editionRepositoryProvider.overrideWithValue(FailingEditionRepository()),
            localCacheServiceProvider.overrideWithValue(cacheService),
          ],
          child: const TechDailyApp(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Should display cached edition along with offline banner
      expect(find.text('TECH DAILY'), findsWidgets);
      expect(
        find.text("Viewing offline cached edition."),
        findsOneWidget,
      );
    });
  });
}
