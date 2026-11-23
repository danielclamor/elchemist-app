import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/mix_session/presentation/widgets/dialogs/mix_session_add_production_orders_dialog.dart';
import 'package:elchemist_app/features/mix_session/presentation/widgets/mix_session_order_card.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:flutter/material.dart';

class MixSessionOrdersSection extends StatelessWidget {
  final double? width;
  final String mixSessionId;
  final String formulaId;
  final int totalOrdersVolumeMl;
  final List<ProductionOrderSummary> productionOrders;

  const MixSessionOrdersSection({
    super.key,
    this.width,
    required this.mixSessionId,
    required this.formulaId,
    required this.productionOrders,
    required this.totalOrdersVolumeMl,
  });

  @override
  Widget build(BuildContext context) {
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
          Text('Total order volume: $totalOrdersVolumeMl mL'),
          ...List.generate(
            productionOrders.length,
            (index) => MixSessionOrderCard(
              mixSessionId: mixSessionId,
              order: productionOrders[index],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => MixSessionAddProductionOrdersDialog(
                      mixSessionId: mixSessionId,
                      formulaId: formulaId,
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('+ Order'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
