import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/features/formula/presentation/widgets/pre_mix_chip.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/screens/production_order_detail_screen.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_mix_chip.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_priority_chip.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_status_chip.dart';
import 'package:elchemist_app/features/production_order/providers/production_order_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProductionOrderListTile extends ConsumerStatefulWidget {
  final ProductionOrderSummary order;

  const ProductionOrderListTile({
    super.key,
    required this.order,
  });

  @override
  ConsumerState<ProductionOrderListTile> createState() =>
      _ProductionOrderListTileState();
}

class _ProductionOrderListTileState
    extends ConsumerState<ProductionOrderListTile> {
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

  ProductionOrderMixChip? _getMixChip(
    String? sessionNumber,
    ProductionOrderStatusChip statusChip,
  ) {
    if (sessionNumber == null) {
      return null;
    }

    return ProductionOrderMixChip(
      labelText: sessionNumber,
      fgColor: statusChip.fgColor,
      bgColor: statusChip.bgColor,
    );
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
    final order = widget.order;

    final isClosed = order.status == ProductionOrderStatus.cancelled ||
        order.status == ProductionOrderStatus.delivered;

    final ProductionOrderStatusChip statusChip = _getStatusChip(order.status);
    final ProductionOrderMixChip? mixChip =
        _getMixChip(order.mixSessionMixNumber, statusChip);
    final String formattedDate = _getFormattedDate(order.createdAt);
    final renderPriority =
        order.isPriority && order.status != ProductionOrderStatus.delivered;

    final textStyle = TextStyle(
      fontSize: 14,
      color: isClosed
          ? Colors.grey
          : renderPriority
              ? Colors.red.shade200
              : null,
      decoration: order.status == ProductionOrderStatus.cancelled
          ? TextDecoration.lineThrough
          : null,
      decorationColor: Colors.grey,
      decorationThickness: 1.0,
    );

    return ListTile(
      tileColor: isClosed ? Theme.of(context).scaffoldBackgroundColor : null,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductionOrderDetailScreen(
              id: order.id,
            ),
          ),
        );
      },
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      minLeadingWidth: 0,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          spacing: 12.0,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ElCheckbox(
                value: ref.watch(productionOrderSelectedTilesProvider.select(
                  (selectedMap) => selectedMap.containsKey(order.id),
                )),
                onChanged: (_) {
                  ref
                      .read(productionOrderSelectedTilesProvider.notifier)
                      .toggle(order);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '#${order.orderNumber}',
                style: textStyle,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                order.eliquidDescription,
                style: textStyle,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                formattedDate,
                style: textStyle,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                order.orderedQuantity != null
                    ? order.orderedQuantity.toString()
                    : '—',
                style: textStyle,
                textAlign: TextAlign.end,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  order.fulfilledQuantity != null
                      ? order.fulfilledQuantity.toString()
                      : '—',
                  style: textStyle,
                  textAlign: TextAlign.end,
                ),
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
              child: order.formulaIsPreMix ?? false
                  ? Container(
                      alignment: AlignmentGeometry.centerLeft,
                      child: PreMixChip(
                        fgColor: Colors.black,
                        bgColor: Colors.grey,
                      ),
                    )
                  : SizedBox.shrink(),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: AlignmentGeometry.centerLeft,
                child: mixChip,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: AlignmentGeometry.centerLeft,
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
