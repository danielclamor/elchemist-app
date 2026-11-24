import 'package:elchemist_app/core/widgets/el_checkbox.dart';
import 'package:elchemist_app/core/widgets/el_text_field.dart';
import 'package:elchemist_app/features/nic_base_option/domain/nic_base_option.dart';
import 'package:elchemist_app/features/recipe/domain/mix_parameters.dart';
import 'package:flutter/material.dart';

class NicBaseEntry {
  NicBaseEntry({
    required this.id,
    this.code,
    required this.name,
    required this.isVg,
    double ratio = 0,
  })  : percController = TextEditingController(text: (ratio * 100).toString()),
        percFocusNode = FocusNode();

  /// From a formula's nic base option (the old path).
  factory NicBaseEntry.fromOption(NicBaseOption option, {double? ratio}) =>
      NicBaseEntry(
        id: option.id,
        code: option.code,
        name: option.name,
        isVg: option.isVg,
        ratio: ratio ?? 0,
      );

  /// From the GraphQL mix parameters.
  factory NicBaseEntry.fromMixParameters(MixParametersNicBase n) =>
      NicBaseEntry(
        id: n.id,
        code: n.code,
        name: n.name,
        isVg: n.isVg,
        ratio: n.ratio,
      );

  final String id;
  final String? code;
  final String name;
  final bool isVg;
  final TextEditingController percController;
  final FocusNode percFocusNode;

  double get ratio => (double.tryParse(percController.text) ?? 0) / 100;

  String get label => code != null ? '$name ($code)' : name;

  void dispose() {
    percController.dispose();
    percFocusNode.dispose();
  }
}

class NicBaseEntryRow extends StatelessWidget {
  final NicBaseEntry entry;
  final bool isCustom;
  final VoidCallback? onRemoved;
  final ValueChanged<String>? onPercentSubmitted;

  NicBaseEntryRow({
    required this.entry,
    this.isCustom = false,
    this.onRemoved,
    this.onPercentSubmitted,
  }) : super(key: ValueKey(entry.id));

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.0,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isCustom
            ? SizedBox(
                width: 30,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    shape: const CircleBorder(),
                  ),
                  onPressed: onRemoved,
                  child: const Icon(Icons.close, size: 14),
                ),
              )
            : SizedBox.shrink(),
        Expanded(
          flex: 4,
          child: Text(
            entry.label,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 100),
            child: ElTextField(
              controller: entry.percController,
              focusNode: entry.percFocusNode,
              contentType: ElTextFieldContentType.numeric,
              // labelText: 'Percentage',
              suffixText: '%',
              readOnly: onPercentSubmitted == null,
              onSubmitted: onPercentSubmitted,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: AlignmentGeometry.center,
            child: ElCheckbox(
              // labelText: 'VG',
              value: entry.isVg,
            ),
          ),
        ),
      ],
    );
  }
}
