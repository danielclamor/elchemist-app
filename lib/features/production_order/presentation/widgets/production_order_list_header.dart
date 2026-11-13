import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/providers/production_order_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductionOrderListHeader extends ConsumerWidget {
  final List<ProductionOrderSummary> orders;
  final Color? cardColor;

  const ProductionOrderListHeader({
    super.key,
    required this.orders,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = const TextStyle(
      fontSize: 14.0,
    );

    final selectedMap = ref.watch(productionOrderSelectedTilesProvider);

    final int selectedCount =
        orders.where((order) => selectedMap.containsKey(order.id)).length;

    final bool? checkBoxValue;
    if (orders.isEmpty || selectedCount == 0) {
      checkBoxValue = false;
    } else if (selectedCount == orders.length) {
      checkBoxValue = true;
    } else {
      checkBoxValue = null;
    }

    return Card(
      color: cardColor,
      margin: EdgeInsets.zero,
      elevation: 0.0,
      shape: RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          spacing: 12.0,
          children: [
            Row(
              spacing: 4.0,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ElCheckbox(
                    value: checkBoxValue,
                    onChanged: orders.isEmpty
                        ? null
                        : (_) {
                            final notifier = ref.read(
                                productionOrderSelectedTilesProvider.notifier);

                            if (checkBoxValue == true) {
                              notifier.clear();
                            } else {
                              notifier.selectAll(orders);
                            }
                          },
                    tristate: true,
                  ),
                ),
                Expanded(flex: 2, child: Text("Order", style: style)),
                Expanded(flex: 3, child: Text("E-liquid", style: style)),
                Expanded(flex: 1, child: Text("Ordered", style: style)),
                Expanded(flex: 1, child: Text("Fulfilled", style: style)),
                Expanded(flex: 2, child: Text("Date", style: style)),
                Expanded(flex: 1, child: Text("Assigned to", style: style)),
                Expanded(flex: 1, child: Text("Status", style: style)),
                Expanded(flex: 1, child: Text("Priority", style: style)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
