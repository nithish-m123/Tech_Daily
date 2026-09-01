import 'package:flutter_test/flutter_test.dart';
import 'package:tech_daily/core/constants/app_constants.dart';
import 'package:tech_daily/features/edition/data/mock_edition_repository.dart';

void main() {
  group('MockEditionRepository Tests', () {
    late MockEditionRepository repository;

    setUp(() {
      repository = MockEditionRepository(latency: Duration.zero);
    });

    test('getTodayEdition returns a fully populated edition', () async {
      final edition = await repository.getTodayEdition();

      expect(edition.title, AppConstants.appName);
      expect(edition.biggestStory, isNotNull);
      expect(edition.biggestStory!.sources.isNotEmpty, isTrue);
      expect(edition.hotTopic, isNotNull);
      expect(edition.hotTopicDescription, isNotNull);

      // Verify stories cover multiple required categories
      expect(edition.stories.isNotEmpty, isTrue);
      expect(edition.stories.length, greaterThanOrEqualTo(20));

      final categories = edition.categories;
      expect(categories.contains(AppConstants.catAi), isTrue);
      expect(categories.contains(AppConstants.catDev), isTrue);
      expect(categories.contains(AppConstants.catBigTech), isTrue);
      expect(categories.contains(AppConstants.catStartups), isTrue);
      expect(categories.contains(AppConstants.catSecurity), isTrue);
      expect(categories.contains(AppConstants.catCloud), isTrue);
      expect(categories.contains(AppConstants.catResearch), isTrue);
      expect(categories.contains(AppConstants.catWorld), isTrue);

      // Verify every story has headline, summary, and whyItMatters
      for (final story in edition.stories) {
        expect(story.headline.isNotEmpty, isTrue);
        expect(story.summary.isNotEmpty, isTrue);
        expect(story.whyItMatters.isNotEmpty, isTrue);
      }
    });

    test('getEdition returns valid historical edition for date', () async {
      final targetDate = DateTime(2026, 8, 31);
      final edition = await repository.getEdition(targetDate);

      expect(edition.biggestStory, isNotNull);
      expect(edition.stories.isNotEmpty, isTrue);
      expect(edition.date.year, 2026);
      expect(edition.date.month, 8);
      expect(edition.date.day, 31);
    });

    test('getArchiveDates returns 7 historical dates', () async {
      final dates = await repository.getArchiveDates();
      expect(dates.length, 7);
      expect(dates.first.isBefore(DateTime.now()), isTrue);
    });
  });
}
