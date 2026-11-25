import 'package:elchemist_app/core/utils/date_helper.dart';
import 'package:elchemist_app/core/widgets/el_checkbox.dart';
import 'package:elchemist_app/features/formula/presentation/widgets/pre_mix_chip.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/screens/production_order_detail_screen.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_mix_chip.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_priority_chip.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_status_chip.dart';
import 'package:elchemist_app/features/production_order/providers/production_order_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  ProductionOrderStatusChip _getStatusChip(
      bool isCanceled, ProductionOrderStatus? status) {
    if (status == null) {
      return ProductionOrderStatusChip(
        labelIcon: null,
        labelText: "",
        fgColor: Colors.grey,
        bgColor: Colors.grey,
      );
    }

    return ProductionOrderStatusChip.fromStatus(
      isCanceled: isCanceled,
      status: status,
    );
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

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    final isArchived = order.isArchived;

    final ProductionOrderStatusChip statusChip = _getStatusChip(
      order.isCanceled,
      order.status,
    );
    final ProductionOrderMixChip? mixChip =
        _getMixChip(order.mixSessionMixNumber, statusChip);
    final String formattedDate = order.createdAt.toTileDateString();
    final renderPriority = order.isPriority && !isArchived;

    final textStyle = TextStyle(
      fontSize: 14,
      color: isArchived
          ? Colors.grey
          : renderPriority
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
