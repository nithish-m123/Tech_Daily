import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_daily/core/constants/app_constants.dart';
import 'package:tech_daily/features/edition/domain/edition.dart';

void main() {
  group('Dynamic Edition Curation Pipeline Schema Validation', () {
    test('Correctly parses generated live edition JSON file', () async {
      final file = File('data/edition_today.json');
      expect(file.existsSync(), isTrue, reason: 'data/edition_today.json should exist');

      final jsonStr = await file.readAsString();
      final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);

      final edition = Edition.fromJson(jsonMap);

      expect(edition.title, equals('Tech Daily'));
      expect(edition.date, isNotNull);
      expect(edition.biggestStory, isNotNull);
      expect(edition.biggestStory!.headline, isNotEmpty);
      expect(edition.biggestStory!.summary, isNotEmpty);
      expect(edition.biggestStory!.whyItMatters, isNotEmpty);
      expect(edition.biggestStory!.keyPoints, isNotEmpty);
      expect(edition.biggestStory!.sources, isNotEmpty);

      expect(edition.stories, isNotEmpty);
      for (final story in edition.stories) {
        expect(story.id, isNotEmpty);
        expect(story.headline, isNotEmpty);
        expect(story.summary, isNotEmpty);
        expect(story.whyItMatters, isNotEmpty);
        expect(story.keyPoints, isNotEmpty);
        expect(story.sources, isNotEmpty);
        expect(AppConstants.allCategories.contains(story.category), isTrue,
            reason: 'Story category "${story.category}" must be one of the 8 curated categories');
      }
    });
  });
}
