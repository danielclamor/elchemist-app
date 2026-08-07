import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/nic_base_entry_row.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NicBaseSection extends StatelessWidget {
  final double? width;
  final TextEditingController nicStrController;
  final ValueChanged<String>? onNicStrSubmitted;
  final TextEditingController vgController;
  final ValueChanged<String>? onVGSubmitted;
  final TextEditingController pgController;
  final ValueChanged<String>? onPGSubmitted;
  final List<NicBaseEntryRow> nicBaseEntries;
  final Widget? addEntryButton;

  NicBaseSection({
    super.key,
    this.width,
    required this.nicStrController,
    this.onNicStrSubmitted,
    required this.vgController,
    this.onVGSubmitted,
    required this.pgController,
    this.onPGSubmitted,
    List<NicBaseEntryRow>? nicBaseEntries,
    this.addEntryButton,
  }) : nicBaseEntries = nicBaseEntries ?? [];

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      width: width,
      title: "NIC BASE",
      child: Column(
        children: [
          ElTextField(
            controller: nicStrController,
            contentType: ElTextFieldContentType.numeric,
            labelText: 'Nic Str',
            labelPosition: ElTextFieldLabelPosition.left,
            readOnly: onNicStrSubmitted == null,
            suffixText: '%',
            onSubmitted: onNicStrSubmitted,
          ),
          const Gap(8.0),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: ElTextField(
                  controller: vgController,
                  contentType: ElTextFieldContentType.numeric,
                  labelText: 'VG',
                  labelPosition: ElTextFieldLabelPosition.left,
                  readOnly: onVGSubmitted == null,
                  suffixText: '%',
                  onSubmitted: onVGSubmitted,
                ),
              ),
              Expanded(
                child: ElTextField(
                  controller: pgController,
                  contentType: ElTextFieldContentType.numeric,
                  labelText: 'PG',
                  labelPosition: ElTextFieldLabelPosition.left,
                  readOnly: onPGSubmitted == null,
                  suffixText: '%',
                  onSubmitted: onPGSubmitted,
                ),
              ),
            ],
          ),
          nicBaseEntries.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    const Gap(16.0),
                    Divider(
                      thickness: 1,
                      color: Theme.of(context).focusColor,
                    ),
                    const Gap(16.0),
                    Column(
                      spacing: 8.0,
                      children: nicBaseEntries,
                    ),
                  ],
                ),
          addEntryButton ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
