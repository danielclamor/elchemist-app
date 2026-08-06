import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:flutter/material.dart';

class FlavoringSection extends StatelessWidget {
  final double width;
  final List<Widget> flavoringEntries;

  const FlavoringSection({
    super.key,
    required this.width,
    required this.flavoringEntries,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      width: width,
      title: 'FLAVOURING',
      child: Column(
        children: [
          ...flavoringEntries,
        ],
      ),
    );
  }
}
