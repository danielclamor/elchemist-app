import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:flutter/material.dart';

class ProductionOrderCard extends StatelessWidget {
  final ProductionOrderSummary productionOrder;

  const ProductionOrderCard({
    super.key,
    required this.productionOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productionOrder.orderNumber),
                  Text(productionOrder.eliquidDescription),
                  Text('Qty: ${productionOrder.orderedQuantity.toString()}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
