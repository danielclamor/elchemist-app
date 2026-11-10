import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/features/diy_mix/providers/diy_mix_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiyMixFlavoringEntryRow extends ConsumerStatefulWidget {
  final DiyMixFlavoringEntry entry;

  const DiyMixFlavoringEntryRow({
    super.key,
    required this.entry,
  });

  @override
  ConsumerState<DiyMixFlavoringEntryRow> createState() =>
      _DiyMixFlavoringEntryRowState();
}

class _DiyMixFlavoringEntryRowState
    extends ConsumerState<DiyMixFlavoringEntryRow> {
  late final _nameController = TextEditingController(text: widget.entry.name);
  late final _percController = TextEditingController(
    text:
        widget.entry.percentage == 0 ? '' : widget.entry.percentage.toString(),
  );

  bool get _isVg => widget.entry.isVg;

  late final _nameFocus = FocusNode()..addListener(_onFocusChange);
  late final _percFocus = FocusNode()..addListener(_onFocusChange);

  void _onFocusChange() {
    if (!mounted) return;
    if (!_nameFocus.hasFocus && !_percFocus.hasFocus) _commit();
  }

  void _commit({bool? isVg}) =>
      ref.read(diyMixFlavoringEntriesProvider.notifier).update(
            widget.entry.id,
            name: _nameController.text,
            percentage: _percController.text,
            isVg: isVg ?? _isVg,
          );

  @override
  void dispose() {
    _nameFocus.dispose();
    _percFocus.dispose();
    _nameController.dispose();
    _percController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              shape: const CircleBorder(),
            ),
            onPressed: () => ref
                .read(diyMixFlavoringEntriesProvider.notifier)
                .remove(widget.entry.id),
            child: const Icon(Icons.close, size: 14),
          ),
        ),
        Expanded(
          flex: 3,
          child: ElTextField(
            controller: _nameController,
            focusNode: _nameFocus,
            contentType: ElTextFieldContentType.text,
            onSubmitted: (_) => _commit(),
          ),
        ),
        Expanded(
          flex: 2,
          child: ElTextField(
            controller: _percController,
            focusNode: _percFocus,
            contentType: ElTextFieldContentType.numeric,
            suffixText: '%',
            onSubmitted: (_) => _commit(),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: AlignmentGeometry.center,
            child: ElCheckbox(
              value: _isVg,
              onChanged: (value) => _commit(isVg: value),
            ),
          ),
        ),
      ],
    );
  }
}
