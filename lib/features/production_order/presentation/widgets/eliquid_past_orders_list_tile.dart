import 'package:elchemist_app/core/utils/date_helper.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/screens/production_order_detail_screen.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_status_chip.dart';
import 'package:flutter/material.dart';

class EliquidPastOrdersPreviewListTile extends StatelessWidget {
  final ProductionOrderSummary order;

  const EliquidPastOrdersPreviewListTile({
    super.key,
    required this.order,
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

  @override
  Widget build(BuildContext context) {
    final isClosed = order.isClosed;

    final ProductionOrderStatusChip statusChip = _getStatusChip(order.status);
    final String formattedDate = order.createdAt.toTileDateString();

    final textStyle = TextStyle(
      fontSize: 14,
      color: isClosed
          ? Colors.grey
          : order.isPriority
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
          spacing: 4.0,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                '#${order.orderNumber}',
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
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                order.fulfilledQuantity != null
                    ? order.fulfilledQuantity.toString()
                    : '—',
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
              flex: 2,
              child: Container(
                alignment: AlignmentGeometry.centerLeft,
                child: statusChip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
