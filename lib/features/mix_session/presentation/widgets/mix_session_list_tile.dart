import 'package:elchemist_app/features/mix_session/domain/mix_session.dart';
import 'package:elchemist_app/features/mix_session/presentation/screens/mix_session_mix_screen.dart';
import 'package:elchemist_app/features/formula/presentation/widgets/pre_mix_chip.dart';
import 'package:elchemist_app/features/mix_session/presentation/widgets/mix_session_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MixSessionListTile extends StatelessWidget {
  final MixSessionSummary batch;

  const MixSessionListTile({super.key, required this.batch});

  MixSessionStatusChip _getStatusChip(MixSessionStatus status) {
    return switch (status) {
      MixSessionStatus.cancelled => MixSessionStatusChip.cancelled(),
      MixSessionStatus.completed => MixSessionStatusChip.completed(),
      MixSessionStatus.inProgress => MixSessionStatusChip.inProgress(),
      MixSessionStatus.mixed => MixSessionStatusChip.mixed(),
    };
  }

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
      final monthDay = DateFormat('MMM d').format(local); // ex. "Sep 9"
      return '$monthDay at $timeStr';
    }

    final monthDayYear =
        DateFormat('MMM d, y').format(local); // ex. "Sep 9, 2025"
    return '$monthDayYear at $timeStr';
  }

  @override
  Widget build(BuildContext context) {
    final isClosed = batch.status == MixSessionStatus.cancelled ||
        batch.status == MixSessionStatus.completed;

    final formattedCreatedAtDate = _getFormattedDate(batch.createdAt);
    final mixedAt = batch.mixedAt;
    final formattedMixedAtDate =
        mixedAt != null ? _getFormattedDate(mixedAt) : "";

    final textStyle = TextStyle(
      fontSize: 14,
      color: isClosed ? Colors.grey : null,
      decoration: batch.status == MixSessionStatus.cancelled
          ? TextDecoration.lineThrough
          : null,
      decorationColor: Colors.grey,
      decorationThickness: 1.0,
    );

    return ListTile(
      tileColor: isClosed ? Theme.of(context).scaffoldBackgroundColor : null,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => MixSessionMixScreen(id: batch.id)),
        );
      },
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      minLeadingWidth: 0,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          spacing: 4.0,
          children: [
            Expanded(
              flex: 2,
              child: Text(batch.sessionNumber, style: textStyle),
            ),
            Expanded(
              flex: 4,
              child: Row(
                spacing: 8.0,
                children: [
                  Text(batch.formulaName, style: textStyle),
                  if (batch.formulaIsPreMix)
                    PreMixChip(
                      fgColor: _getStatusChip(batch.status).fgColor,
                      bgColor: _getStatusChip(batch.status).bgColor,
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(formattedCreatedAtDate, style: textStyle),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: AlignmentGeometry.centerLeft,
                child: _getStatusChip(batch.status),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(formattedMixedAtDate, style: textStyle),
            ),
            Expanded(
              flex: 2,
              child: Text(batch.batchCode ?? "", style: textStyle),
            ),
          ],
        ),
      ),
    );
  }
}
