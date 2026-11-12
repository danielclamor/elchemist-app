import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FormulaDetailTargetSection extends StatelessWidget {
  final double? width;
  final double nicStr;
  final double vg;
  final double pg;

  const FormulaDetailTargetSection({
    super.key,
    this.width,
    required this.nicStr,
    required this.vg,
    required this.pg,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      width: width,
      title: 'TARGET',
      child: Column(
        children: [
          ElTextField(
            controller: TextEditingController(text: (nicStr * 100).toString()),
            contentType: ElTextFieldContentType.numeric,
            labelText: 'Nic Str',
            labelPosition: ElTextFieldLabelPosition.left,
            readOnly: true,
            suffixText: '%',
            onSubmitted: (value) {},
          ),
          const Gap(8.0),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: ElTextField(
                  controller:
                      TextEditingController(text: (vg * 100).toString()),
                  contentType: ElTextFieldContentType.numeric,
                  labelText: 'VG',
                  labelPosition: ElTextFieldLabelPosition.left,
                  readOnly: true,
                  suffixText: '%',
                  onSubmitted: (value) {},
                ),
              ),
              Expanded(
                child: ElTextField(
                  controller:
                      TextEditingController(text: (pg * 100).toString()),
                  contentType: ElTextFieldContentType.numeric,
                  labelText: 'PG',
                  labelPosition: ElTextFieldLabelPosition.left,
                  readOnly: true,
                  suffixText: '%',
                  onSubmitted: (value) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
