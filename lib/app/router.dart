import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/archive/presentation/archive_screen.dart';
import '../features/edition/presentation/edition_screen.dart';
import '../features/liked/presentation/liked_news_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'today',
      builder: (BuildContext context, GoRouterState state) {
        return const EditionScreen();
      },
    ),
    GoRoute(
      path: '/archive',
      name: 'archive',
      builder: (BuildContext context, GoRouterState state) {
        return const ArchiveScreen();
      },
    ),
    GoRoute(
      path: '/liked',
      name: 'liked',
      builder: (BuildContext context, GoRouterState state) {
        return const LikedNewsScreen();
      },
    ),
    GoRoute(
      path: '/edition/:date',
      name: 'archiveEdition',
      builder: (BuildContext context, GoRouterState state) {
        final dateParam = state.pathParameters['date'];
        DateTime? parsedDate;
        if (dateParam != null) {
          parsedDate = DateTime.tryParse(dateParam);
        }
        return EditionScreen(archiveDate: parsedDate);
      },
    ),
  ],
);
