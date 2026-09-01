import 'package:flutter_test/flutter_test.dart';
import 'package:tech_daily/features/edition/domain/edition.dart';
import 'package:tech_daily/features/story/domain/source.dart';
import 'package:tech_daily/features/story/domain/story.dart';

void main() {
  group('Source Model Tests', () {
    test('Source serializes and deserializes correctly', () {
      final json = {
        'name': 'Reuters',
        'url': 'https://reuters.com/tech',
      };

      final source = Source.fromJson(json);
      expect(source.name, 'Reuters');
      expect(source.url, 'https://reuters.com/tech');

      final serialized = source.toJson();
      expect(serialized['name'], 'Reuters');
      expect(serialized['url'], 'https://reuters.com/tech');
    });

    test('Source equality works as expected', () {
      const s1 = Source(name: 'Reuters', url: 'https://reuters.com');
      const s2 = Source(name: 'Reuters', url: 'https://reuters.com');
      const s3 = Source(name: 'Bloomberg', url: 'https://bloomberg.com');

      expect(s1, equals(s2));
      expect(s1 == s3, isFalse);
    });
  });

  group('Story Model Tests', () {
    test('Story deserializes from snake_case API payload', () {
      final json = {
        'id': 'story_101',
        'category': 'AI & MACHINE LEARNING',
        'headline': 'New Breakthrough in Small Models',
        'summary': 'Researchers achieved state-of-the-art results.',
        'why_it_matters': 'Enables fast on-device inference.',
        'key_points': ['Point 1', 'Point 2'],
        'published_at': '2026-09-01T08:00:00Z',
        'importance': 9,
        'sources': [
          {'name': 'Nature', 'url': 'https://nature.com'},
        ],
        'estimated_read_minutes': 3,
      };

      final story = Story.fromJson(json);
      expect(story.id, 'story_101');
      expect(story.category, 'AI & MACHINE LEARNING');
      expect(story.headline, 'New Breakthrough in Small Models');
      expect(story.summary, 'Researchers achieved state-of-the-art results.');
      expect(story.whyItMatters, 'Enables fast on-device inference.');
      expect(story.keyPoints.length, 2);
      expect(story.sources.length, 1);
      expect(story.sources.first.name, 'Nature');
      expect(story.estimatedReadMinutes, 3);
    });

    test('Story serializes to JSON map', () {
      final story = Story(
        id: 'test_story',
        category: 'CLOUD',
        headline: 'Cloud update',
        summary: 'Cloud summary',
        whyItMatters: 'Important for infra',
        keyPoints: const ['K1', 'K2'],
        publishedAt: DateTime(2026, 9, 1),
        sources: const [Source(name: 'AWS', url: 'https://aws.amazon.com')],
      );

      final map = story.toJson();
      expect(map['id'], 'test_story');
      expect(map['category'], 'CLOUD');
      expect(map['why_it_matters'], 'Important for infra');
      expect(map['key_points'], ['K1', 'K2']);
    });
  });

  group('Edition Model Tests', () {
    test('Edition parses correctly with biggest story and categories', () {
      final json = {
        'id': 'edition_today',
        'date': '2026-09-01',
        'title': 'Tech Daily',
        'hot_topic': {
          'title': 'AI Agents',
          'description': 'Rise of autonomous tools.',
          'related_story_ids': ['s1'],
        },
        'biggest_story': {
          'id': 'hero_01',
          'category': 'AI & MACHINE LEARNING',
          'headline': 'Major LLM Launched',
          'summary': 'Summary of hero',
          'why_it_matters': 'Impact of hero',
          'key_points': ['P1'],
          'published_at': '2026-09-01T06:00:00Z',
          'sources': [],
        },
        'stories': [
          {
            'id': 's1',
            'category': 'DEVELOPERS',
            'headline': 'Flutter 4.0 Released',
            'summary': 'New compiler improvements.',
            'why_it_matters': 'Faster apps.',
            'key_points': [],
            'published_at': '2026-09-01T07:00:00Z',
            'sources': [],
          },
          {
            'id': 's2',
            'category': 'DEVELOPERS',
            'headline': 'Rust 2.0 Spec',
            'summary': 'Memory safety improvements.',
            'why_it_matters': 'Fewer bugs.',
            'key_points': [],
            'published_at': '2026-09-01T07:30:00Z',
            'sources': [],
          },
        ],
      };

      final edition = Edition.fromJson(json);
      expect(edition.id, 'edition_today');
      expect(edition.title, 'Tech Daily');
      expect(edition.hotTopic, 'AI Agents');
      expect(edition.hotTopicDescription, 'Rise of autonomous tools.');
      expect(edition.biggestStory?.id, 'hero_01');
      expect(edition.stories.length, 2);
      expect(edition.totalStoryCount, 3); // hero + 2 stories
      expect(edition.categories, ['DEVELOPERS']);
      expect(edition.storiesForCategory('DEVELOPERS').length, 2);
    });
  });
}
