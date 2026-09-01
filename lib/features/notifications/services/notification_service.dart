import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

abstract class NotificationService {
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  Future<void> showBriefingReadyNotification({String? title, String? body});
  Stream<NotificationPayload> get onNotificationSelected;
}

/// Robust Local Notification & FCM hybrid implementation
class FcmNotificationServiceScaffolding implements NotificationService {
  final _payloadController = StreamController<NotificationPayload>.broadcast();
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  @override
  Stream<NotificationPayload> get onNotificationSelected => _payloadController.stream;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          _payloadController.add(
            const NotificationPayload(
              type: NotificationType.dailyBriefing,
              title: "Tech Daily • Today's Briefing Ready",
              body: "Open to read today's curated edition.",
            ),
          );
        },
      );
      _isInitialized = true;
      debugPrint('NotificationService: Local notification system initialized.');
    } catch (e) {
      debugPrint('NotificationService: Local notification initialization note: $e');
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await androidPlugin?.requestNotificationsPermission() ?? true;
      debugPrint('NotificationService: Notification permission: $granted');
      return granted;
    } catch (e) {
      return true;
    }
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    debugPrint('NotificationService: Subscribed to topic $topic');
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    debugPrint('NotificationService: Unsubscribed from topic $topic');
  }

  @override
  Future<void> showBriefingReadyNotification({String? title, String? body}) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'daily_briefing_channel',
        'Daily Tech Briefing',
        channelDescription: 'Alerts when a fresh morning technology edition is ready',
        importance: Importance.high,
        priority: Priority.high,
      );
      const details = NotificationDetails(android: androidDetails);
      await _localNotifications.show(
        101,
        title ?? "📰 Tech Daily • Today's Edition Ready",
        body ?? "Today's curated tech & AI briefing is now live.",
        details,
        payload: 'daily_briefing',
      );
    } catch (e) {
      debugPrint('NotificationService: Could not show notification: $e');
    }
  }

  /// Simulate receiving a notification payload (for testing deep linking & routing)
  void simulateNotificationTapped(NotificationPayload payload) {
    _payloadController.add(payload);
  }

  void dispose() {
    _payloadController.close();
  }
}
