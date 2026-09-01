import 'dart:async';
import 'package:flutter/foundation.dart';

enum NotificationType {
  dailyBriefing,
  breakingNews,
  unknown,
}

class NotificationPayload {
  final NotificationType type;
  final String? storyId;
  final DateTime? editionDate;
  final String? title;
  final String? body;

  const NotificationPayload({
    required this.type,
    this.storyId,
    this.editionDate,
    this.title,
    this.body,
  });

  factory NotificationPayload.fromMap(Map<String, dynamic> map) {
    final typeString = map['type'] as String? ?? '';
    NotificationType type = NotificationType.unknown;
    if (typeString == 'daily_briefing') {
      type = NotificationType.dailyBriefing;
    } else if (typeString == 'breaking_news') {
      type = NotificationType.breakingNews;
    }

    DateTime? parsedDate;
    if (map['edition_date'] != null) {
      parsedDate = DateTime.tryParse(map['edition_date'].toString());
    }

    return NotificationPayload(
      type: type,
      storyId: map['story_id'] as String?,
      editionDate: parsedDate,
      title: map['title'] as String?,
      body: map['body'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type == NotificationType.dailyBriefing
          ? 'daily_briefing'
          : (type == NotificationType.breakingNews ? 'breaking_news' : 'unknown'),
      if (storyId != null) 'story_id': storyId,
      if (editionDate != null) 'edition_date': editionDate!.toIso8601String(),
      if (title != null) 'title': title,
      if (body != null) 'body': body,
    };
  }
}

/// Abstract notification service enabling seamless transition to Firebase Cloud Messaging (FCM)
abstract class NotificationService {
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  Stream<NotificationPayload> get onNotificationSelected;
}

/// Production scaffolding implementation for Firebase Cloud Messaging
class FcmNotificationServiceScaffolding implements NotificationService {
  final _payloadController = StreamController<NotificationPayload>.broadcast();

  @override
  Stream<NotificationPayload> get onNotificationSelected => _payloadController.stream;

  @override
  Future<void> initialize() async {
    debugPrint('NotificationService: Initialized FCM scaffolding.');
    // When Firebase configuration is provided, configure FirebaseMessaging listeners:
    // FirebaseMessaging.onMessageOpenedApp.listen(...)
    // FirebaseMessaging.instance.getInitialMessage(...)
  }

  @override
  Future<bool> requestPermission() async {
    debugPrint('NotificationService: Requesting push notification permission.');
    return true;
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    debugPrint('NotificationService: Subscribed to topic $topic');
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    debugPrint('NotificationService: Unsubscribed from topic $topic');
  }

  /// Simulate receiving a notification payload (for testing deep linking & routing)
  void simulateNotificationTapped(NotificationPayload payload) {
    _payloadController.add(payload);
  }

  void dispose() {
    _payloadController.close();
  }
}
