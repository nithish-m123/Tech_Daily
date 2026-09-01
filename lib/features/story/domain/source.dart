class Source {
  final String name;
  final String url;

  const Source({
    required this.name,
    required this.url,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      name: json['name'] as String? ?? 'Source',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Source &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          url == other.url;

  @override
  int get hashCode => name.hashCode ^ url.hashCode;

  @override
  String toString() => 'Source(name: $name, url: $url)';
}
