import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/providers/production_order_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductionOrderStatusCard extends ConsumerWidget {
  final String label;
  final ProductionOrderStatus status;

  const ProductionOrderStatusCard(
      {super.key, required this.label, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(productionOrderStatusFilterProvider) == status;
    final count = ref.watch(productionOrderStatusCountsProvider).value?[status];
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () =>
          ref.read(productionOrderStatusFilterProvider.notifier).toggle(status),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? scheme.primary.withValues(alpha: 0.15) : null,
          border: Border(right: BorderSide(width: 1.0, color: scheme.surface)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              count?.toString() ?? '—',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
