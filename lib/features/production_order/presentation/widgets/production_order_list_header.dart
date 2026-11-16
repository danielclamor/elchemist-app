import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/features/mix_session/presentation/screens/mix_session_mix_screen.dart';
import 'package:elchemist_app/features/mix_session/providers/mix_session_providers.dart';
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

    final selectedIds = selectedMap.values.map((o) => o.id).toList();

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
        child: Row(
          spacing: 12.0,
          children: selectedCount > 0
              ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ElCheckbox(
                      value: checkBoxValue,
                      onChanged: orders.isEmpty
                          ? null
                          : (_) {
                              final notifier = ref.read(
                                  productionOrderSelectedTilesProvider
                                      .notifier);

                              if (checkBoxValue == true) {
                                notifier.clear();
                              } else {
                                notifier.selectAll(orders);
                              }
                            },
                      tristate: true,
                    ),
                  ),
                  Text(
                    '$selectedCount selected',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        ref
                            .read(productionOrderSelectedTilesProvider.notifier)
                            .clear();

                        final mixSessionId = await ref
                            .read(mixSessionRepositoryProvider)
                            .createWithProductionOrders(
                              productionOrderIds: selectedIds,
                            );

                        if (!context.mounted || mixSessionId == null) return;

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => MixSessionMixScreen(id: mixSessionId),
                        ));
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                        ));
                      }
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey,
                    ),
                    child: Text('Mix a batch'),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        ref
                            .read(productionOrderSelectedTilesProvider.notifier)
                            .clear();
                        for (final id in selectedIds) {
                          await ref
                              .read(productionOrderRepositoryProvider)
                              .markCancelled(id: id);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                          ));
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      foregroundColor: Colors.red,
                      backgroundColor: Colors.red.withAlpha(25),
                    ),
                    child: Text('Cancel orders'),
                  ),
                ]
              : [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ElCheckbox(
                      value: checkBoxValue,
                      onChanged: orders.isEmpty
                          ? null
                          : (_) {
                              final notifier = ref.read(
                                  productionOrderSelectedTilesProvider
                                      .notifier);

                              if (checkBoxValue == true) {
                                notifier.clear();
                              } else {
                                notifier.selectAll(orders);
                              }
                            },
                      tristate: true,
                    ),
                  ),
                  Expanded(flex: 1, child: Text("Order", style: style)),
                  Expanded(flex: 3, child: Text("E-liquid", style: style)),
                  Expanded(flex: 2, child: Text("Date", style: style)),
                  Expanded(
                      flex: 1,
                      child: Text(
                        "Ordered",
                        style: style,
                        textAlign: TextAlign.end,
                      )),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        "Fulfilled",
                        style: style,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  Expanded(flex: 1, child: Text("Status", style: style)),
                  Expanded(flex: 1, child: Text("Premix", style: style)),
                  Expanded(flex: 1, child: Text("Assigned to", style: style)),
                  Expanded(flex: 1, child: Text("Priority", style: style)),
                ],
        ),
      ),
    );
  }
}
