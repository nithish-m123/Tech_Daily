import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../story/domain/story.dart';
import 'edition_providers.dart';

class LikedStoriesNotifier extends Notifier<List<Story>> {
  @override
  List<Story> build() {
    _loadLikedStories();
    return [];
  }

  Future<void> _loadLikedStories() async {
    final cacheService = ref.read(localCacheServiceProvider);
    final stories = await cacheService.getLikedStories();
    state = stories;
  }

  Future<bool> toggleLike(Story story) async {
    final cacheService = ref.read(localCacheServiceProvider);
    final isLiked = await cacheService.toggleLikeStory(story);
    await _loadLikedStories();
    return isLiked;
  }

  bool isLiked(String storyId) {
    return state.any((s) => s.id == storyId);
  }
}

final likedStoriesProvider =
    NotifierProvider<LikedStoriesNotifier, List<Story>>(LikedStoriesNotifier.new);
