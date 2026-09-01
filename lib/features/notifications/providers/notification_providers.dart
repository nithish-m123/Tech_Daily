import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = FcmNotificationServiceScaffolding();
  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
});

final notificationStreamProvider = StreamProvider<NotificationPayload>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return service.onNotificationSelected;
});
