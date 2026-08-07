import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:flutter/material.dart';

class BatchSection extends StatelessWidget {
  final double? width;
  final TextEditingController volumeController;
  final ValueChanged<String>? onVolumeSubmitted;

  const BatchSection({
    super.key,
    this.width,
    required this.volumeController,
    this.onVolumeSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      width: width,
      title: 'BATCH',
      child: ElTextField(
        controller: volumeController,
        contentType: ElTextFieldContentType.numeric,
        labelText: 'Volume',
        labelPosition: ElTextFieldLabelPosition.left,
        suffixText: 'mL',
        onSubmitted: onVolumeSubmitted,
      ),
    );
  }
}
