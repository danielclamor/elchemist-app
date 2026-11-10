import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/diy_mix/providers/diy_mix_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class DiyMixNicBaseSection extends ConsumerStatefulWidget {
  final double? width;

  const DiyMixNicBaseSection({
    super.key,
    this.width,
  });

  @override
  ConsumerState<DiyMixNicBaseSection> createState() =>
      _DiyMixNicBaseSectionState();
}

class _DiyMixNicBaseSectionState extends ConsumerState<DiyMixNicBaseSection> {
  late final TextEditingController _nicStrController;
  late final TextEditingController _vgController;
  late final TextEditingController _pgController;

  @override
  void initState() {
    super.initState();
    _nicStrController = TextEditingController(
        text: ref.read(diyMixNicBaseNicStrPercProvider).toString());
    _vgController = TextEditingController(
        text: ref.read(diyMixNicBaseVgPercProvider).toString());
    _pgController = TextEditingController(
        text: ref.read(diyMixNicBasePgPercProvider).toString());

    ref.listenManual(
      diyMixNicBaseVgPercProvider,
      (_, value) => _vgController.text = value.toString(),
    );
    ref.listenManual(
      diyMixNicBasePgPercProvider,
      (_, value) => _pgController.text = value.toString(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nicStrController.dispose();
    _vgController.dispose();
    _pgController.dispose();
  }

  void _commitVg() =>
      ref.read(diyMixNicBaseVgPercProvider.notifier).set(_vgController.text);

  void _commitPg() => ref
      .read(diyMixNicBaseVgPercProvider.notifier)
      .set((100 - (double.tryParse(_pgController.text) ?? 0)).toString());

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      width: widget.width,
      title: "NIC BASE",
      child: Column(
        children: [
          ElTextField(
            controller: _nicStrController,
            contentType: ElTextFieldContentType.numeric,
            labelText: 'Nic Str',
            labelPosition: ElTextFieldLabelPosition.left,
            suffixText: '%',
            onSubmitted: (value) =>
                ref.read(diyMixNicBaseNicStrPercProvider.notifier).set(value),
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
                  suffixText: '%',
                  onSubmitted: (_) => _commitVg(),
                ),
              ),
              Expanded(
                child: ElTextField(
                  controller: _pgController,
                  contentType: ElTextFieldContentType.numeric,
                  labelText: 'PG',
                  labelPosition: ElTextFieldLabelPosition.left,
                  suffixText: '%',
                  onSubmitted: (value) => _commitPg(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
