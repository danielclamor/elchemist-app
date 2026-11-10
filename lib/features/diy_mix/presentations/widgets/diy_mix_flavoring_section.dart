import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/diy_mix/presentations/widgets/diy_mix_flavoring_entry_row.dart';
import 'package:elchemist_app/features/diy_mix/providers/diy_mix_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class DiyMixFlavoringSection extends ConsumerWidget {
  final double? width;

  const DiyMixFlavoringSection({super.key, this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(diyMixFlavoringEntriesProvider);
    final headerTextStyle = TextStyle(
      fontSize: 12,
      color: Colors.grey,
    );

    return SectionCard(
      width: width,
      title: 'FLAVOURING',
      child: Column(
        children: [
          if (entries.isNotEmpty)
            Row(
              spacing: 8.0,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                ),
                Expanded(flex: 3, child: Text('Name', style: headerTextStyle)),
                Expanded(
                    flex: 2, child: Text('Percentage', style: headerTextStyle)),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: AlignmentGeometry.center,
                    child: Text('VG', style: headerTextStyle),
                  ),
                ),
              ],
            ),
          for (final e in entries) ...[
            DiyMixFlavoringEntryRow(key: ValueKey(e.id), entry: e),
            const Gap(8.0),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed:
                    ref.read(diyMixFlavoringEntriesProvider.notifier).add,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('+ Flavouring'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
