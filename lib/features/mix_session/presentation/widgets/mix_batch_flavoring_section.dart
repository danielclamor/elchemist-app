import 'package:elchemist_app/features/flavoring_option.dart/domain/flavoring_option.dart';
import 'package:elchemist_app/features/formula/domain/flavoring.dart';
import 'package:elchemist_app/features/formula/presentation/widgets/flavoring_entry_row.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MixBatchFlavoringSection extends StatefulWidget {
  final double? width;
  final List<Flavoring> flavorings;
  final bool isCustom;
  final Widget? addEntryButton;

  const MixBatchFlavoringSection({
    super.key,
    this.width,
    required this.flavorings,
    this.isCustom = false,
    this.addEntryButton,
  });

  @override
  State<MixBatchFlavoringSection> createState() =>
      _MixBatchFlavoringSectionState();
}

class _MixBatchFlavoringSectionState extends State<MixBatchFlavoringSection> {
  final _flavoringEntries = <String, FlavoringEntry>{};

  FlavoringEntry _flavoringEntry(FlavoringOption o, double? ratio) =>
      _flavoringEntries.putIfAbsent(
          o.id, () => FlavoringEntry(flavoringOption: o, ratio: ratio));

  @override
  Widget build(BuildContext context) {
    final isCustom = widget.isCustom;
    final flavorings = widget.flavorings;

    return SectionCard(
      width: widget.width,
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
              children: List.generate(
                flavorings.length,
                (index) {
                  final flavoring = flavorings[index];
                  final entry = _flavoringEntry(
                    flavoring.flavoringOption,
                    flavoring.ratio,
                  );
                  return FlavoringEntryRow(
                    entry: entry,
                    isCustom: isCustom,
                    onPercentSubmitted:
                        isCustom ? (value) => setState(() {}) : null,
                  );
                },
              )),
        ],
      ),
    );
  }
}
