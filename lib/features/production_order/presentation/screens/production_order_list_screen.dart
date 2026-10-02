import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/screens/production_order_create_order_screen.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_filter_status_card.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_table.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductionOrderListScreen extends StatefulWidget {
  const ProductionOrderListScreen({super.key});

  @override
  State<ProductionOrderListScreen> createState() =>
      _ProductionOrderListScreenState();
}

class _ProductionOrderListScreenState extends State<ProductionOrderListScreen> {
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductionOrderCreateOrderScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E76BD),
                    side: BorderSide(
                      color: const Color(0xFF0B5E97),
                      width: 1.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                  ),
                  child: Text(
                    "Create Order",
                    style: const TextStyle(
                      color: Color(0xFFDAF0FF),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            Card(
              elevation: 2.0,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 1.0,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48.0,
                          vertical: 16.0,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16.0,
                            ),
                            Gap(12.0),
                            Text(
                              'Today',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: ProductionOrderStatusCard(
                      label: 'Pending',
                      status: ProductionOrderStatus.pending,
                    ),
                  ),
                  const Expanded(
                    child: ProductionOrderStatusCard(
                      label: 'In progress',
                      status: ProductionOrderStatus.inProgress,
                    ),
                  ),
                  const Expanded(
                    child: ProductionOrderStatusCard(
                      label: 'Fulfilled',
                      status: ProductionOrderStatus.fulfilled,
                    ),
                  ),
                  const Expanded(
                    child: ProductionOrderStatusCard(
                      label: 'Delivered',
                      status: ProductionOrderStatus.delivered,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Card(
                elevation: 2.0,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: EdgeInsets.zero,
                child: ProductionOrderListTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
