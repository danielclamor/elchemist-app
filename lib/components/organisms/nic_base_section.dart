import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NicBaseSection extends StatelessWidget {
  final double? width;
  final bool textFieldReadOnly;
  final TextEditingController nicStrController;
  final TextEditingController vgController;
  final TextEditingController pgController;
  final Widget nicBaseEntries;
  final Widget? addEntryButton;

  const NicBaseSection({
    super.key,
    this.width,
    this.textFieldReadOnly = true,
    required this.nicStrController,
    required this.vgController,
    required this.pgController,
    required this.nicBaseEntries,
    this.addEntryButton,
  });

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
            readOnly: textFieldReadOnly,
            suffixText: '%',
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
                  readOnly: textFieldReadOnly,
                  suffixText: '%',
                ),
              ),
              Expanded(
                child: ElTextField(
                  controller: pgController,
                  contentType: ElTextFieldContentType.numeric,
                  labelText: 'PG',
                  labelPosition: ElTextFieldLabelPosition.left,
                  readOnly: textFieldReadOnly,
                  suffixText: '%',
                ),
              ),
            ],
          ),
          nicBaseEntries,
          addEntryButton ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
