import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _editionDateFormat = DateFormat('MMMM d, y');
  static final DateFormat _archiveDateFormat = DateFormat('EEEE, MMMM d, y');
  static final DateFormat _dateKeyFormat = DateFormat('yyyy-MM-dd');

  /// Format as: "September 1, 2026"
  static String formatEditionDate(DateTime date) {
    return _editionDateFormat.format(date);
  }

  /// Format as: "Tuesday, September 1, 2026"
  static String formatArchiveDate(DateTime date) {
    return _archiveDateFormat.format(date);
  }

  /// Format as date key: "2026-09-01"
  static String formatDateKey(DateTime date) {
    return _dateKeyFormat.format(date);
  }

  /// Check if two dates are the same calendar day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
