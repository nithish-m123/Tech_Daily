import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/storage/local_cache_service.dart';
import '../data/api_edition_repository.dart';
import '../data/edition_repository.dart';
import '../data/mock_edition_repository.dart';
import '../domain/edition.dart';

/// Provides the local cache service
final localCacheServiceProvider = Provider<LocalCacheService>((ref) {
  return LocalCacheService();
});

/// Provides the active EditionRepository (Mock or API depending on feature flag)
final editionRepositoryProvider = Provider<EditionRepository>((ref) {
  if (FeatureFlags.useMockRepository) {
    return MockEditionRepository();
  }
  return ApiEditionRepository();
});

/// State for the current edition view
class EditionViewState {
  final Edition? edition;
  final bool isLoading;
  final bool isFromCache;
  final String? errorMessage;

  const EditionViewState({
    this.edition,
    this.isLoading = false,
    this.isFromCache = false,
    this.errorMessage,
  });

  EditionViewState copyWith({
    Edition? edition,
    bool? isLoading,
    bool? isFromCache,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EditionViewState(
      edition: edition ?? this.edition,
      isLoading: isLoading ?? this.isLoading,
      isFromCache: isFromCache ?? this.isFromCache,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Manages today's edition fetching, offline caching, and refresh logic
class TodayEditionNotifier extends Notifier<EditionViewState> {
  @override
  EditionViewState build() {
    // Schedule initial load after build
    Future.microtask(() => loadTodayEdition());
    return const EditionViewState(isLoading: true);
  }

  /// Initial load or retry: first checks local cache for instant display, then refreshes from repo
  Future<void> loadTodayEdition() async {
    final cacheService = ref.read(localCacheServiceProvider);
    final repository = ref.read(editionRepositoryProvider);

    // 1. Try to load cached edition first for instant startup
    final cached = await cacheService.getLatestCachedEdition();
    if (cached != null) {
      state = EditionViewState(
        edition: cached,
        isLoading: true, // Still fetching latest in background
        isFromCache: true,
      );
    } else {
      state = state.copyWith(isLoading: true, clearError: true);
    }

    // 2. Fetch latest edition from repository
    try {
      final latest = await repository.getTodayEdition();
      // Cache successful response
      await cacheService.saveLatestEdition(latest);

      state = EditionViewState(
        edition: latest,
        isLoading: false,
        isFromCache: false,
      );
    } catch (e) {
      // 3. Handle failure: if we had cached edition, keep displaying it with offline flag
      if (state.edition != null) {
        state = state.copyWith(
          isLoading: false,
          isFromCache: true,
        );
      } else {
        // No cache available, show error state
        state = const EditionViewState(
          isLoading: false,
          errorMessage: 'Unable to load today\'s edition.\nPlease check your connection and try again.',
        );
      }
    }
  }

  /// Pull-to-refresh action
  Future<void> refresh() async {
    final repository = ref.read(editionRepositoryProvider);
    final cacheService = ref.read(localCacheServiceProvider);

    try {
      final latest = await repository.getTodayEdition();
      await cacheService.saveLatestEdition(latest);
      state = EditionViewState(
        edition: latest,
        isLoading: false,
        isFromCache: false,
      );
    } catch (e) {
      // Keep existing data on refresh error, mark as cached
      state = state.copyWith(
        isFromCache: true,
      );
    }
  }
}

final todayEditionProvider =
    NotifierProvider<TodayEditionNotifier, EditionViewState>(TodayEditionNotifier.new);

/// Family provider for loading a specific archived edition by date
final archiveEditionProvider =
    FutureProvider.family<Edition, DateTime>((ref, date) async {
  final repository = ref.watch(editionRepositoryProvider);
  final cacheService = ref.watch(localCacheServiceProvider);

  // Check cache first
  final cached = await cacheService.getCachedEdition(date);
  if (cached != null) {
    return cached;
  }

  final edition = await repository.getEdition(date);
  return edition;
});

/// Provider for available archive dates
final archiveDatesProvider = FutureProvider<List<DateTime>>((ref) async {
  final repository = ref.watch(editionRepositoryProvider);
  return repository.getArchiveDates();
});
