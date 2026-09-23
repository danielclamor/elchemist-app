import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_job_chip.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_priority_chip.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductionOrderListTile extends StatelessWidget {
  final String orderNumber,
      eliquidDescription,
      orderedQuantity,
      fulfilledQuantity;
  final DateTime createdAt;
  final ProductionOrderStatus status;
  final ProductionOrderJob? job;
  final bool isPriority;
  final bool isCancelled;

  const ProductionOrderListTile({
    super.key,
    required this.orderNumber,
    required this.eliquidDescription,
    required this.orderedQuantity,
    required this.fulfilledQuantity,
    required this.createdAt,
    required this.status,
    required this.job,
    required this.isPriority,
    this.isCancelled = false,
  });

  ProductionOrderStatusChip _getStatusChip(ProductionOrderStatus status) {
    switch (status) {
      case ProductionOrderStatus.cancelled:
        return ProductionOrderStatusChip.cancelled();
      case ProductionOrderStatus.delivered:
        return ProductionOrderStatusChip.delivered();
      case ProductionOrderStatus.fulfilled:
        return ProductionOrderStatusChip.fulfilled();
      case ProductionOrderStatus.inProgress:
        return ProductionOrderStatusChip.inProgress();
      case ProductionOrderStatus.pending:
        return ProductionOrderStatusChip.pending();
    }
  }

  ProductionOrderJobChip _getJobChip(
    ProductionOrderJob? job,
    ProductionOrderStatusChip statusChip,
  ) {
    if (job == null) {
      return ProductionOrderJobChip.unassigned();
    }

    switch (job) {
      case ProductionOrderJob.mix:
        return ProductionOrderJobChip.mix(
          fgColor: statusChip.fgColor,
          bgColor: statusChip.bgColor,
        );
      case ProductionOrderJob.repat:
        return ProductionOrderJobChip.repat(
          fgColor: statusChip.fgColor,
          bgColor: statusChip.bgColor,
        );
    }
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
    final ProductionOrderStatusChip statusChip = _getStatusChip(status);
    final ProductionOrderJobChip jobChip = _getJobChip(job, statusChip);
    final String formattedDate = _getFormattedDate(createdAt);
    final renderPriority =
        isPriority && status != ProductionOrderStatus.delivered;

    return ListTile(
      onTap: () {}, // TODO: implement onTap
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      leading: renderPriority
          ? Container(
              width: 4.0,
              color: Colors.red.shade300,
            )
          : null,
      minLeadingWidth: 0,
      title: Padding(
        padding: renderPriority
            ? const EdgeInsets.fromLTRB(0, 0, 16, 0)
            : const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          spacing: 4.0,
          children: [
            Expanded(flex: 2, child: Text(orderNumber)),
            Expanded(flex: 3, child: Text(eliquidDescription)),
            Expanded(flex: 1, child: Text(orderedQuantity)),
            Expanded(flex: 1, child: Text(fulfilledQuantity)),
            Expanded(flex: 2, child: Text(formattedDate)),
            Expanded(
              flex: 1,
              child: Container(
                alignment: AlignmentGeometry.centerLeft,
                child: jobChip,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: AlignmentGeometry.centerLeft,
                child: statusChip,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: AlignmentGeometry.center,
                child: renderPriority
                    ? ProductionOrderPriorityChip()
                    : SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
