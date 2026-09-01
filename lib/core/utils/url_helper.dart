import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  /// Opens an external URL in the device's system browser
  static Future<bool> openArticleUrl(String url) async {
    if (url.trim().isEmpty) {
      debugPrint('UrlHelper: URL is empty');
      return false;
    }

    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        debugPrint('UrlHelper: Could not launch $url');
      }
      return launched;
    } catch (e) {
      debugPrint('UrlHelper: Error launching URL: $e');
      return false;
    }
  }
}
