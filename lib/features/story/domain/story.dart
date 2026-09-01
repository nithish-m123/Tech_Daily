import 'source.dart';

class Story {
  final String id;
  final String category;
  final String headline;
  final String summary;
  final String whyItMatters;
  final List<String> keyPoints;
  final DateTime publishedAt;
  final DateTime? updatedAt;
  final int importance; // e.g. 1-10
  final List<Source> sources;
  final String? imageUrl;
  final int estimatedReadMinutes;

  const Story({
    required this.id,
    required this.category,
    required this.headline,
    required this.summary,
    required this.whyItMatters,
    required this.keyPoints,
    required this.publishedAt,
    this.updatedAt,
    this.importance = 5,
    this.sources = const [],
    this.imageUrl,
    this.estimatedReadMinutes = 2,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      headline: json['headline'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      whyItMatters: json['why_it_matters'] as String? ?? (json['whyItMatters'] as String? ?? ''),
      keyPoints: (json['key_points'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          (json['keyPoints'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'].toString()) ?? DateTime.now()
          : (json['publishedAt'] != null
              ? DateTime.tryParse(json['publishedAt'].toString()) ?? DateTime.now()
              : DateTime.now()),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : (json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'].toString())
              : null),
      importance: (json['importance'] as num?)?.toInt() ?? 5,
      sources: (json['sources'] as List<dynamic>?)
              ?.map((e) => Source.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      estimatedReadMinutes: (json['estimated_read_minutes'] as num?)?.toInt() ??
          (json['estimatedReadMinutes'] as num?)?.toInt() ??
          2,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'headline': headline,
      'summary': summary,
      'why_it_matters': whyItMatters,
      'key_points': keyPoints,
      'published_at': publishedAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      'importance': importance,
      'sources': sources.map((s) => s.toJson()).toList(),
      if (imageUrl != null) 'image_url': imageUrl,
      'estimated_read_minutes': estimatedReadMinutes,
    };
  }

  Story copyWith({
    String? id,
    String? category,
    String? headline,
    String? summary,
    String? whyItMatters,
    List<String>? keyPoints,
    DateTime? publishedAt,
    DateTime? updatedAt,
    int? importance,
    List<Source>? sources,
    String? imageUrl,
    int? estimatedReadMinutes,
  }) {
    return Story(
      id: id ?? this.id,
      category: category ?? this.category,
      headline: headline ?? this.headline,
      summary: summary ?? this.summary,
      whyItMatters: whyItMatters ?? this.whyItMatters,
      keyPoints: keyPoints ?? this.keyPoints,
      publishedAt: publishedAt ?? this.publishedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      importance: importance ?? this.importance,
      sources: sources ?? this.sources,
      imageUrl: imageUrl ?? this.imageUrl,
      estimatedReadMinutes: estimatedReadMinutes ?? this.estimatedReadMinutes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Story && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
