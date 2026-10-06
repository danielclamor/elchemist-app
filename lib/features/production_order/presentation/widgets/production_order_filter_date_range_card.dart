import 'package:elchemist_app/features/production_order/domain/production_order_date_range.dart';
import 'package:elchemist_app/features/production_order/presentation/providers/production_order_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ProductionOrderFilterDateRangeCard extends ConsumerWidget {
  const ProductionOrderFilterDateRangeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preset = ref.watch(productionOrderDatePresetProvider);
    final notifier = ref.read(productionOrderDatePresetProvider.notifier);

    return PopupMenuButton<DatePreset?>(
      tooltip: '',
      onSelected: notifier.select,
      offset: Offset(0, 4),
      position: PopupMenuPosition.under,
      itemBuilder: (_) => [
        for (final p in DatePreset.values)
          PopupMenuItem(
            value: p,
            child: Text(p.label),
          ),
      ],
      child: InkWell(
        child: Container(
          width: 160,
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16.0,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            border: Border(
              right: BorderSide(
                width: 1.0,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_today,
                size: 16.0,
              ),
              Gap(12.0),
              Text(
                preset?.label ?? 'All time',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
