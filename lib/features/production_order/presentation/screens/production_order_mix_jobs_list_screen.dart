import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/screens/production_order_create_order_screen.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_filters.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_table.dart';
import 'package:flutter/material.dart';

class ProductionOrderMixJobListScreen extends StatefulWidget {
  const ProductionOrderMixJobListScreen({super.key});

  @override
  State<ProductionOrderMixJobListScreen> createState() =>
      _ProductionOrderMixJobListScreenState();
}

class _ProductionOrderMixJobListScreenState
    extends State<ProductionOrderMixJobListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width >= 800
              ? MediaQuery.of(context).size.width - 280
              : MediaQuery.of(context).size.width,
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Production Orders",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            ProductionOrderFilters(),
            Expanded(
              child: ProductionOrderListTable(
                jobType: ProductionOrderJobType.mix,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
