import '../domain/edition.dart';

abstract class EditionRepository {
  /// Fetches today's published edition
  Future<Edition> getTodayEdition();

  /// Fetches an archived edition for a specific date
  Future<Edition> getEdition(DateTime date);

  /// Returns available archive dates
  Future<List<DateTime>> getArchiveDates();
}
