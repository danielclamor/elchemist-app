import 'package:elchemist_app/components/molecules/flavoring_entry_row.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:flutter/material.dart';

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
