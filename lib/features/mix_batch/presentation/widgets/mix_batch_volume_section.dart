import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/mix_batch/providers/mix_batch_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MixBatchVolumeSection extends ConsumerStatefulWidget {
  final double? width;

  const MixBatchVolumeSection({super.key, this.width});

  @override
  ConsumerState<MixBatchVolumeSection> createState() =>
      _MixBatchVolumeSectionState();
}

class _MixBatchVolumeSectionState extends ConsumerState<MixBatchVolumeSection> {
  late final TextEditingController _volumeController;

  @override
  void initState() {
    super.initState();
    _volumeController = TextEditingController(text: "0");
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.invalidate(mixBatchVolumeMlValueProvider));
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      width: widget.width,
      title: 'BATCH',
      child: ElTextField(
        controller: _volumeController,
        contentType: ElTextFieldContentType.numeric,
        labelText: 'Volume',
        labelPosition: ElTextFieldLabelPosition.left,
        suffixText: 'mL',
        onSubmitted: (value) =>
            ref.read(mixBatchVolumeMlValueProvider.notifier).set(value),
      ),
    );
  }
}
