import 'package:elchemist_app/features/formula/presentation/widgets/flavoring_entry_row.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FlavoringSection extends StatelessWidget {
  final double? width;
  final List<FlavoringEntryRow> flavoringEntries;
  final Widget? addEntryButton;

  const FlavoringSection({
    super.key,
    this.width,
    required this.flavoringEntries,
    this.addEntryButton,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      width: width,
      title: 'FLAVOURING',
      child: Column(
        children: [
          Row(
            spacing: 4.0,
            children: [
              Expanded(
                  flex: 4,
                  child: Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )),
              Expanded(
                  flex: 4,
                  child: Text(
                    'Percentage',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.right,
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    'VG',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ))
            ],
          ),
          const Gap(8.0),
          Column(
            spacing: 8.0,
            children: flavoringEntries,
          ),
          addEntryButton ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
