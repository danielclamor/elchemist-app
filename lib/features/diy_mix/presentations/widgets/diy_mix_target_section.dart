import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/diy_mix/providers/diy_mix_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class DiyMixTargetSection extends ConsumerStatefulWidget {
  final double? width;

  const DiyMixTargetSection({
    super.key,
    this.width,
  });

  @override
  ConsumerState<DiyMixTargetSection> createState() =>
      _DiyMixTargetSectionState();
}

class _DiyMixTargetSectionState extends ConsumerState<DiyMixTargetSection> {
  late final TextEditingController _nicStrController;
  late final TextEditingController _vgController;
  late final TextEditingController _pgController;

  @override
  void initState() {
    super.initState();
    _nicStrController = TextEditingController(
        text: ref.read(diyMixTargetNicStrPercProvider).toString());
    _vgController = TextEditingController(
        text: ref.read(diyMixTargetVgPercProvider).toString());
    _pgController = TextEditingController(
        text: ref.read(diyMixTargetPgPercProvider).toString());

    ref.listenManual(
      diyMixTargetVgPercProvider,
      (_, value) => _vgController.text = value.toString(),
    );
    ref.listenManual(
      diyMixTargetPgPercProvider,
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
      ref.read(diyMixTargetVgPercProvider.notifier).set(_vgController.text);

  void _commitPg() => ref
      .read(diyMixTargetVgPercProvider.notifier)
      .set((100 - (double.tryParse(_pgController.text) ?? 0)).toString());

  @override
  Widget build(BuildContext context) {
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
            suffixText: '%',
            onSubmitted: (value) =>
                ref.read(diyMixTargetNicStrPercProvider.notifier).set(value),
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
