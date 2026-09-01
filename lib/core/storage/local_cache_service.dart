import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../utils/date_formatter.dart';
import '../../features/edition/domain/edition.dart';
import '../../features/story/domain/story.dart';

class LocalCacheService {
  static const String likedStoriesKey = 'user_liked_stories_json';
  final SharedPreferences? _prefs;

  LocalCacheService([this._prefs]);

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  /// Caches the latest fetched edition
  Future<bool> saveLatestEdition(Edition edition) async {
    try {
      final prefs = await _getPrefs();
      final jsonMap = edition.toJson();
      final jsonString = jsonEncode(jsonMap);

      await prefs.setString(AppConstants.latestEditionKey, jsonString);
      final dateKey = DateFormatter.formatDateKey(edition.date);
      await prefs.setString('${AppConstants.editionPrefixKey}$dateKey', jsonString);

      return true;
    } catch (e) {
      debugPrint('LocalCacheService: Error saving latest edition: $e');
      return false;
    }
  }

  /// Retrieves the latest saved edition
  Future<Edition?> getLatestCachedEdition() async {
    try {
      final prefs = await _getPrefs();
      final jsonString = prefs.getString(AppConstants.latestEditionKey);
      if (jsonString == null || jsonString.isEmpty) {
        return null;
      }
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return Edition.fromJson(jsonMap);
    } catch (e) {
      debugPrint('LocalCacheService: Error reading cached latest edition: $e');
      return null;
    }
  }

  /// Retrieves a specific archived edition
  Future<Edition?> getCachedEdition(DateTime date) async {
    try {
      final prefs = await _getPrefs();
      final dateKey = DateFormatter.formatDateKey(date);
      final jsonString = prefs.getString('${AppConstants.editionPrefixKey}$dateKey');
      if (jsonString == null || jsonString.isEmpty) {
        return null;
      }
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return Edition.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  /// Toggles liked status for a story (Save / Remove from Liked News)
  Future<bool> toggleLikeStory(Story story) async {
    try {
      final prefs = await _getPrefs();
      final likedList = await getLikedStories();
      final index = likedList.indexWhere((s) => s.id == story.id);

      if (index >= 0) {
        // Un-like story
        likedList.removeAt(index);
      } else {
        // Like story
        likedList.insert(0, story);
      }

      final jsonList = likedList.map((s) => s.toJson()).toList();
      await prefs.setString(likedStoriesKey, jsonEncode(jsonList));
      return index < 0; // Returns true if story is now liked
    } catch (e) {
      debugPrint('LocalCacheService: Error toggling like status: $e');
      return false;
    }
  }

  /// Checks if a story ID is liked
  Future<bool> isStoryLiked(String storyId) async {
    try {
      final likedList = await getLikedStories();
      return likedList.any((s) => s.id == storyId);
    } catch (e) {
      return false;
    }
  }

  /// Retrieves list of all liked news stories
  Future<List<Story>> getLikedStories() async {
    try {
      final prefs = await _getPrefs();
      final jsonString = prefs.getString(likedStoriesKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      final List<dynamic> rawList = jsonDecode(jsonString);
      return rawList
          .map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('LocalCacheService: Error reading liked stories: $e');
      return [];
    }
  }
}
