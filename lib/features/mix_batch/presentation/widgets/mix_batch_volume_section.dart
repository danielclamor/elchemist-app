import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/mix_batch/providers/mix_batch_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MixBatchVolumeSection extends ConsumerWidget {
  final double? width;

  const MixBatchVolumeSection({
    super.key,
    this.width,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volumeController = TextEditingController(
      text: ref.watch(mixBatchVolumeMlValueProvider).toString(),
    );

    return SectionCard(
      width: width,
      title: 'BATCH',
      child: ElTextField(
        controller: volumeController,
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
