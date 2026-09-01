import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/story/domain/story.dart';

class ShareHelper {
  /// Shares a story via the native system share sheet across any platform
  static Future<void> shareStory(Story story) async {
    try {
      final primaryUrl = story.sources.isNotEmpty ? story.sources.first.url : 'https://techdaily.news';
      final shareText = '''
📰 ${story.headline}

${story.summary}

Read original on Tech Daily:
$primaryUrl
''';

      // ignore: deprecated_member_use
      await Share.share(
        shareText.trim(),
        subject: story.headline,
      );
    } catch (e) {
      debugPrint('ShareHelper: Error launching share sheet: $e');
    }
  }
}
