import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/mix_session/providers/mix_session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MixSessionVolumeSection extends ConsumerStatefulWidget {
  final double? width;

  const MixSessionVolumeSection({super.key, this.width});

  @override
  ConsumerState<MixSessionVolumeSection> createState() =>
      _MixSessionVolumeSectionState();
}

class _MixSessionVolumeSectionState
    extends ConsumerState<MixSessionVolumeSection> {
  late final TextEditingController _volumeController;

  @override
  void initState() {
    super.initState();
    _volumeController = TextEditingController(text: "0");
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.invalidate(mixSessionVolumeMlValueProvider));
  }

  @override
  void dispose() {
    super.dispose();
    _volumeController.dispose();
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
            ref.read(mixSessionVolumeMlValueProvider.notifier).set(value),
      ),
    );
  }
}
