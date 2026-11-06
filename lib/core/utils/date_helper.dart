import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  String toTileDateString() {
    final local = toLocal();
    final timeStr = DateFormat('h:mm a').format(local);
    final monthDayYear = DateFormat('MMMM d, y').format(local);
    return '$monthDayYear at $timeStr';
  }
}
