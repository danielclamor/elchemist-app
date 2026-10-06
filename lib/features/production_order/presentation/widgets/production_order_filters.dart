import 'package:elchemist_app/core/widgets/fading_horizontal_scroll.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_filter_date_range_card.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_filter_status_card.dart';
import 'package:flutter/material.dart';

class ProductionOrderFilters extends StatefulWidget {
  const ProductionOrderFilters({super.key});

  @override
  State<ProductionOrderFilters> createState() => _ProductionOrderFiltersState();
}

class _ProductionOrderFiltersState extends State<ProductionOrderFilters> {
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _verticalScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                final tableWidth = 1432.0;
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
    );
  }
}
