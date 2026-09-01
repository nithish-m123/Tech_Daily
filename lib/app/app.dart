import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../features/notifications/providers/notification_providers.dart';
import '../features/notifications/services/notification_service.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

class TechDailyApp extends ConsumerStatefulWidget {
  const TechDailyApp({super.key});

  @override
  ConsumerState<TechDailyApp> createState() => _TechDailyAppState();
}

class _TechDailyAppState extends ConsumerState<TechDailyApp> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    // Listen for incoming notifications and route accordingly
    ref.listen<AsyncValue<NotificationPayload>>(
      notificationStreamProvider,
      (previous, next) {
        next.whenData((payload) {
          if (payload.type == NotificationType.breakingNews && payload.editionDate != null) {
            final dateKey = payload.editionDate!.toIso8601String().split('T').first;
            appRouter.go('/edition/$dateKey');
          } else if (payload.type == NotificationType.dailyBriefing) {
            appRouter.go('/');
          }
        });
      },
    );

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
