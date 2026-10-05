import 'package:elchemist_app/core/widgets/fading_horizontal_scroll.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/screens/production_order_create_order_screen.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_filter_date_range_card.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_filter_status_card.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_table.dart';
import 'package:flutter/material.dart';

class ProductionOrderListScreen extends StatefulWidget {
  const ProductionOrderListScreen({super.key});

  @override
  State<ProductionOrderListScreen> createState() =>
      _ProductionOrderListScreenState();
}

class _ProductionOrderListScreenState extends State<ProductionOrderListScreen> {
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _verticalScrollController.dispose();
  }

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
                children: [
                  const ProductionOrderFilterDateRangeCard(),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final tableWidth = 1352.0;
                        final needsScroll = constraints.maxWidth < tableWidth;

                        final metricsContent = SizedBox(
                          width: tableWidth,
                          child: Row(
                            children: [
                              const Expanded(
                                child: ProductionOrderFilterStatusCard(
                                  label: 'Pending',
                                  status: ProductionOrderStatus.pending,
                                ),
                              ),
                              const Expanded(
                                child: ProductionOrderFilterStatusCard(
                                  label: 'In progress',
                                  status: ProductionOrderStatus.inProgress,
                                ),
                              ),
                              const Expanded(
                                child: ProductionOrderFilterStatusCard(
                                  label: 'Fulfilled',
                                  status: ProductionOrderStatus.fulfilled,
                                ),
                              ),
                              const Expanded(
                                child: ProductionOrderFilterStatusCard(
                                  label: 'Delivered',
                                  status: ProductionOrderStatus.delivered,
                                ),
                              ),
                            ],
                          ),
                        );

                        if (needsScroll) {
                          return FadingHorizontalScroll(
                            fadeWidth: 100,
                            controller: _verticalScrollController,
                            child: metricsContent,
                          );
                        }

                        return metricsContent;
                      },
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
