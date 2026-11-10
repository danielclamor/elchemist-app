import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/diy_mix/providers/diy_mix_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiyMixVolumeSection extends ConsumerStatefulWidget {
  final double? width;

  const DiyMixVolumeSection({super.key, this.width});

  @override
  ConsumerState<DiyMixVolumeSection> createState() =>
      _DiyMixVolumeSectionState();
}

class _DiyMixVolumeSectionState extends ConsumerState<DiyMixVolumeSection> {
  late final TextEditingController _volumeController;

  @override
  void initState() {
    super.initState();
    _volumeController = TextEditingController(text: "0");
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.invalidate(diyMixVolumeMlValueProvider));
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
            ref.read(diyMixVolumeMlValueProvider.notifier).set(value),
      ),
    );
  }
}
