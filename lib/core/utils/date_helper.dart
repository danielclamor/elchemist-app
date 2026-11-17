import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isSameWeek(DateTime a, DateTime b) {
    final startA = _startOfWeek(a);
    final startB = _startOfWeek(b);
    return startA.year == startB.year &&
        startA.month == startB.month &&
        startA.day == startB.day;
  }

  DateTime _startOfWeek(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final daysSinceMonday = dateOnly.weekday - DateTime.monday; // Monday = 1
    return dateOnly.subtract(Duration(days: daysSinceMonday));
  }

  String _getFormattedDate(DateTime datetime) {
    final local = datetime.toLocal();
    final now = DateTime.now();

    final timeStr = DateFormat('h:mm a').format(local); // ex. "9:00 PM"

    if (_isSameDay(local, now)) {
      return 'Today at $timeStr';
    }

    if (_isSameWeek(local, now)) {
      final weekday = DateFormat('EEEE').format(local); // ex."Thursday"
      return '$weekday at $timeStr';
    }

    if (local.year == now.year) {
      final monthDay = DateFormat('MMMM d').format(local); // ex. "Sep 9"
      return '$monthDay at $timeStr';
    }

    final monthDayYear =
        DateFormat('MMM d, y').format(local); // ex. "Sep 9, 2025"
    return '$monthDayYear at $timeStr';
  }

  String toTileDateString() {
    return _getFormattedDate(this);
  }
}
