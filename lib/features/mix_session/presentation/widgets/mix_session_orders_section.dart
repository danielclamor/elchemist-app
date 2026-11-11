import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/cards/production_order_card.dart';
import 'package:flutter/material.dart';

class MixSessionOrdersSection extends StatelessWidget {
  final double? width;
  final List<ProductionOrderSummary> productionOrders;

  const MixSessionOrdersSection({
    super.key,
    this.width,
    required this.productionOrders,
  });

  @override
  Widget build(BuildContext context) {
    final totalVolumeMl = productionOrders
        .map((o) => o.eliquidBottleSize.toInt() * (o.orderedQuantity ?? 0))
        .fold(0, (sum, volumeMl) => sum + volumeMl);

    return SectionCard(
      width: width,
      title: "ORDERS",
      titleTrailing: Text(
        productionOrders.length.toString(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade400,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          Text('Total order volume: $totalVolumeMl'),
          ...List.generate(
            productionOrders.length,
            (index) {
              final productionOrder = productionOrders[index];
              return ProductionOrderCard(productionOrder: productionOrder);
            },
          )
        ],
      ),
    );
  }
}
