import 'package:elchemist_app/core/widgets/el_text_field.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session.dart';
import 'package:elchemist_app/features/mix_session/providers/mix_session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MixSessionVolumeSection extends ConsumerStatefulWidget {
  final double? width;
  final MixSession mixSession;

  const MixSessionVolumeSection({
    super.key,
    this.width,
    required this.mixSession,
  });

  @override
  ConsumerState<MixSessionVolumeSection> createState() =>
      _MixSessionVolumeSectionState();
}

class _MixSessionVolumeSectionState
    extends ConsumerState<MixSessionVolumeSection> {
  late final TextEditingController _volumeController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _volumeController = TextEditingController(
      text: (widget.mixSession.batchVolumeMl ?? 0).toString(),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _volumeController.dispose();
    super.dispose();
  }

  Future<void> _saveVolume(String value) async {
    final parsed = double.tryParse(value) ?? 0.0;
    final current = ref
        .read(mixSessionDetailsProvider(widget.mixSession.id))
        .value
        ?.batchVolumeMl;

    if (parsed == current) return;

    await ref
        .read(mixSessionDetailsProvider(widget.mixSession.id).notifier)
        .setBatchVolumeMl(value);
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      width: widget.width,
      title: 'BATCH',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 16.0,
        children: [
          ElTextField(
            focusNode: _focusNode,
            controller: _volumeController,
            contentType: ElTextFieldContentType.numeric,
            labelText: 'Volume',
            labelPosition: ElTextFieldLabelPosition.left,
            suffixText: 'mL',
            onSubmitted: (value) => _saveVolume(value),
            onTapOutside: (_) {
              if (_focusNode.hasFocus) {
                _focusNode.unfocus();
                _saveVolume(_volumeController.text);
              }
            },
          ),
          Text(
            'Minimum: ${widget.mixSession.totalOrdersVolumeMl} mL',
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          )
        ],
      ),
    );
  }
}
