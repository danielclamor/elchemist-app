import 'package:elchemist_app/features/mix_batch/domain/mix_batch.dart';
import 'package:elchemist_app/features/mix_batch/presentation/providers/mix_batch_providers.dart';
import 'package:elchemist_app/features/mix_batch/presentation/screens/mix_batch_detail_screen.dart';
import 'package:elchemist_app/features/mix_batch/presentation/widgets/mix_batch_pre_mix_chip.dart';
import 'package:elchemist_app/features/mix_batch/presentation/widgets/mix_batch_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MixBatchListTile extends StatelessWidget {
  final MixBatchSummary batch;

  const MixBatchListTile({super.key, required this.batch});

  MixBatchStatusChip _getStatusChip(MixBatchStatus status) {
    return switch (status) {
      MixBatchStatus.cancelled => MixBatchStatusChip.cancelled(),
      MixBatchStatus.completed => MixBatchStatusChip.completed(),
      MixBatchStatus.inProgress => MixBatchStatusChip.inProgress(),
      MixBatchStatus.mixed => MixBatchStatusChip.mixed(),
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
    final isClosed = batch.status == MixBatchStatus.cancelled ||
        batch.status == MixBatchStatus.completed;

    final formattedCreatedAtDate = _getFormattedDate(batch.createdAt);
    final mixedAt = batch.mixedAt;
    final formattedMixedAtDate =
        mixedAt != null ? _getFormattedDate(mixedAt) : "";

    final textStyle = TextStyle(
      fontSize: 14,
      color: isClosed ? Colors.grey : null,
      decoration: batch.status == MixBatchStatus.cancelled
          ? TextDecoration.lineThrough
          : null,
      decorationColor: Colors.grey,
      decorationThickness: 1.0,
    );

    return ListTile(
      tileColor: isClosed ? Theme.of(context).scaffoldBackgroundColor : null,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => MixBatchDetailScreen(id: batch.id)),
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
            Expanded(flex: 2, child: Text(batch.mixNumber, style: textStyle)),
            Expanded(
                flex: 4,
                child: Row(
                  spacing: 8.0,
                  children: [
                    Text(batch.nicProfileFullName, style: textStyle),
                    if (batch.nicProfileIsPreMix)
                      MixBatchPreMixChip(
                        fgColor: _getStatusChip(batch.status).fgColor,
                        bgColor: _getStatusChip(batch.status).bgColor,
                      )
                  ],
                )),
            Expanded(
                flex: 2, child: Text(formattedCreatedAtDate, style: textStyle)),
            Expanded(
                flex: 1,
                child: Container(
                    alignment: AlignmentGeometry.centerLeft,
                    child: _getStatusChip(batch.status))),
            Expanded(
                flex: 2, child: Text(formattedMixedAtDate, style: textStyle)),
            Expanded(
                flex: 2, child: Text(batch.batchCode ?? "", style: textStyle)),
          ],
        ),
      ),
    );
  }
}
