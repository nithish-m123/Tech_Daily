import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../core/network/api_client.dart';
import '../../../core/utils/date_formatter.dart';
import '../domain/edition.dart';
import 'edition_repository.dart';

class ApiEditionRepository implements EditionRepository {
  final ApiClient _apiClient;

  ApiEditionRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  Future<Edition> getTodayEdition() async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    // 1. Try remote static hosting data/edition_today.json with cache-buster
    try {
      final response = await _apiClient.get<dynamic>('data/edition_today.json?t=$ts');
      if (response.data != null) {
        final Map<String, dynamic> map = response.data is String
            ? jsonDecode(response.data as String) as Map<String, dynamic>
            : (response.data as Map<dynamic, dynamic>).cast<String, dynamic>();
        return Edition.fromJson(map);
      }
    } catch (_) {
      // Fall through
    }

    // 2. Try standard REST API route
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('api/v1/edition/today?t=$ts');
      if (response.data != null) {
        return Edition.fromJson(response.data!);
      }
    } catch (_) {
      // Fall through
    }

    // 3. Fallback to bundled dynamic edition asset
    try {
      final assetStr = await rootBundle.loadString('data/edition_today.json');
      final Map<String, dynamic> map = jsonDecode(assetStr) as Map<String, dynamic>;
      return Edition.fromJson(map);
    } catch (_) {
      throw Exception('Unable to load today\'s edition from remote API or bundled data.');
    }
  }

  @override
  Future<Edition> getEdition(DateTime date) async {
    final dateKey = DateFormatter.formatDateKey(date);
    final ts = DateTime.now().millisecondsSinceEpoch;
    // Tries static hosting data/editions/{date}.json first
    try {
      final response = await _apiClient.get<dynamic>('data/editions/$dateKey.json?t=$ts');
      if (response.data != null) {
        final Map<String, dynamic> map = response.data is String
            ? jsonDecode(response.data as String) as Map<String, dynamic>
            : (response.data as Map<dynamic, dynamic>).cast<String, dynamic>();
        return Edition.fromJson(map);
      }
    } catch (_) {
      // Fall through to API route
    }

    final response = await _apiClient.get<Map<String, dynamic>>('api/v1/edition/$dateKey?t=$ts');
    if (response.data == null) {
      throw Exception('Empty response received for edition on $dateKey');
    }
    return Edition.fromJson(response.data!);
  }

  @override
  Future<List<DateTime>> getArchiveDates() async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    // Tries static hosting data/archive.json first
    try {
      final response = await _apiClient.get<dynamic>('data/archive.json?t=$ts');
      if (response.data != null) {
        final List<dynamic> list = response.data is String
            ? jsonDecode(response.data as String) as List<dynamic>
            : response.data as List<dynamic>;
        return list
            .map((item) => DateTime.tryParse(item.toString()))
            .whereType<DateTime>()
            .toList();
      }
    } catch (_) {
      // Fall through to API route
    }

    final response = await _apiClient.get<List<dynamic>>('api/v1/editions/archive?t=$ts');
    final data = response.data ?? [];
    return data
        .map((item) => DateTime.tryParse(item.toString()))
        .whereType<DateTime>()
        .toList();
  }
}
