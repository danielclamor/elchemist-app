import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NicBaseSection extends StatelessWidget {
  final double? width;
  final TextEditingController targetNicStrController;
  final TextEditingController nicStrController;
  final TextEditingController vgController;
  final TextEditingController pgController;
  final Widget nicBaseEntries;
  final Widget? addEntryButton;

  const NicBaseSection({
    super.key,
    this.width,
    required this.targetNicStrController,
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
            readOnly: true,
            suffix: const Text('%'),
          ),
          const Gap(8.0),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: ElTextField(
                  controller: vgController,
                  contentType: ElTextFieldContentType.numeric,
                  labelText: "VG",
                  labelPosition: ElTextFieldLabelPosition.left,
                  readOnly: true,
                  suffix: const Text('%'),
                ),
              ),
              Expanded(
                child: ElTextField(
                  controller: pgController,
                  contentType: ElTextFieldContentType.numeric,
                  labelText: "PG",
                  labelPosition: ElTextFieldLabelPosition.left,
                  readOnly: true,
                  suffix: const Text('%'),
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
