import '../../story/domain/story.dart';

class Edition {
  final String id;
  final DateTime date;
  final String title;
  final String? hotTopic;
  final String? hotTopicDescription;
  final List<String>? hotTopicRelatedStoryIds;
  final Story? biggestStory;
  final List<Story> stories;

  const Edition({
    required this.id,
    required this.date,
    required this.title,
    this.hotTopic,
    this.hotTopicDescription,
    this.hotTopicRelatedStoryIds,
    this.biggestStory,
    this.stories = const [],
  });

  /// Returns list of unique categories present in this edition's stories
  List<String> get categories {
    final seen = <String>{};
    final result = <String>[];
    for (final s in stories) {
      if (seen.add(s.category)) {
        result.add(s.category);
      }
    }
    return result;
  }

  /// Returns all stories belonging to a given category
  List<Story> storiesForCategory(String category) {
    return stories.where((s) => s.category.toUpperCase() == category.toUpperCase()).toList();
  }

  /// Total count of all curated stories including the biggest story
  int get totalStoryCount {
    var count = stories.length;
    if (biggestStory != null && !stories.any((s) => s.id == biggestStory!.id)) {
      count += 1;
    }
    return count;
  }

  factory Edition.fromJson(Map<String, dynamic> json) {
    // Parse stories list first
    final rawStories = json['stories'] as List<dynamic>? ?? [];
    final parsedStories = rawStories
        .map((e) => Story.fromJson(e as Map<String, dynamic>))
        .toList();

    // Biggest story may be embedded as an object or referenced by ID
    Story? biggest;
    if (json['biggest_story'] != null) {
      biggest = Story.fromJson(json['biggest_story'] as Map<String, dynamic>);
    } else if (json['biggestStory'] != null) {
      biggest = Story.fromJson(json['biggestStory'] as Map<String, dynamic>);
    } else if (json['biggest_story_id'] != null) {
      final id = json['biggest_story_id'] as String;
      biggest = parsedStories.where((s) => s.id == id).firstOrNull;
    }

    // Hot topic can be an object or flat fields
    String? hotTopicTitle;
    String? hotTopicDesc;
    List<String>? relatedIds;

    if (json['hot_topic'] is Map<String, dynamic>) {
      final ht = json['hot_topic'] as Map<String, dynamic>;
      hotTopicTitle = ht['title'] as String?;
      hotTopicDesc = ht['description'] as String?;
      relatedIds = (ht['related_story_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList();
    } else {
      hotTopicTitle = json['hot_topic'] as String? ?? json['hotTopic'] as String?;
      hotTopicDesc = json['hot_topic_description'] as String? ?? json['hotTopicDescription'] as String?;
    }

    DateTime parsedDate;
    if (json['date'] != null) {
      parsedDate = DateTime.tryParse(json['date'].toString()) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return Edition(
      id: json['id'] as String? ?? 'edition_${parsedDate.year}_${parsedDate.month}_${parsedDate.day}',
      date: parsedDate,
      title: json['title'] as String? ?? 'Tech Daily',
      hotTopic: hotTopicTitle,
      hotTopicDescription: hotTopicDesc,
      hotTopicRelatedStoryIds: relatedIds,
      biggestStory: biggest,
      stories: parsedStories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String().split('T').first,
      'title': title,
      if (hotTopic != null)
        'hot_topic': {
          'title': hotTopic,
          'description': hotTopicDescription,
          if (hotTopicRelatedStoryIds != null) 'related_story_ids': hotTopicRelatedStoryIds,
        },
      if (biggestStory != null) 'biggest_story': biggestStory!.toJson(),
      'stories': stories.map((s) => s.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Edition && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
