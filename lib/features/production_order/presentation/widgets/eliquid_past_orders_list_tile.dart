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

  ProductionOrderStatusChip _getStatusChip(ProductionOrderStatus? status) {
    if (status == null) {
      return ProductionOrderStatusChip(
        labelIcon: null,
        labelText: "",
        fgColor: Colors.grey,
        bgColor: Colors.grey,
      );
    }

    return ProductionOrderStatusChip.fromStatus(status: status);
  }

  @override
  Widget build(BuildContext context) {
    final isArchived = order.isArchived;
    final textStyle = TextStyle(
      fontSize: 14,
      color: isArchived
          ? Colors.grey
          : order.isPriority
              ? Colors.red.shade200
              : null,
      decoration: order.isCanceled ? TextDecoration.lineThrough : null,
      decorationColor: Colors.grey,
      decorationThickness: 1.0,
    );

    return ListTile(
      tileColor: isArchived ? Theme.of(context).scaffoldBackgroundColor : null,
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
                order.createdAt.toTileDateString(),
                style: textStyle,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: AlignmentGeometry.centerLeft,
                child: _getStatusChip(order.status),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
