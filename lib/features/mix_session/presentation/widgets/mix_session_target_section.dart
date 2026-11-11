import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MixSessionTargetSection extends StatefulWidget {
  final double? width;
  final double nicStr;
  final double vg;
  final double pg;
  final bool isCustom;

  const MixSessionTargetSection({
    super.key,
    this.width,
    required this.nicStr,
    required this.vg,
    required this.pg,
    this.isCustom = false,
  });

  @override
  State<MixSessionTargetSection> createState() =>
      _MixSessionTargetSectionState();
}

class _MixSessionTargetSectionState extends State<MixSessionTargetSection> {
  late final TextEditingController _nicStrController;
  late final TextEditingController _vgController;
  late final TextEditingController _pgController;

  @override
  void initState() {
    super.initState();
    _nicStrController = TextEditingController(text: '${widget.nicStr * 100}');
    _vgController = TextEditingController(text: '${widget.vg * 100}');
    _pgController = TextEditingController(text: '${widget.pg * 100}');
  }

  @override
  void dispose() {
    super.dispose();
    _nicStrController.dispose();
    _vgController.dispose();
    _pgController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCustom = widget.isCustom;

    return SectionCard(
      width: widget.width,
      title: "TARGET",
      child: Column(
        children: [
          ElTextField(
            controller: _nicStrController,
            contentType: ElTextFieldContentType.numeric,
            labelText: 'Nic Str',
            labelPosition: ElTextFieldLabelPosition.left,
            readOnly: !isCustom,
            suffixText: '%',
            onSubmitted: (value) {},
          ),
          const Gap(8),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: ElTextField(
                  controller: _vgController,
                  contentType: ElTextFieldContentType.numeric,
                  labelText: 'VG',
                  labelPosition: ElTextFieldLabelPosition.left,
                  readOnly: !isCustom,
                  suffixText: '%',
                  onSubmitted: (value) {},
                ),
              ),
              Expanded(
                child: ElTextField(
                  controller: _pgController,
                  contentType: ElTextFieldContentType.numeric,
                  labelText: 'PG',
                  labelPosition: ElTextFieldLabelPosition.left,
                  readOnly: !isCustom,
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
