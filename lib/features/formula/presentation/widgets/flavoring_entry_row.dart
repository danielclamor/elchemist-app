import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/features/flavoring_option.dart/domain/flavoring_option.dart';
import 'package:flutter/material.dart';

class FlavoringEntry {
  FlavoringEntry({
    required this.flavoringOption,
    double? ratio,
  })  : id = flavoringOption.id,
        nameController = TextEditingController(text: flavoringOption.name),
        percController =
            TextEditingController(text: ((ratio ?? 0) * 100).toString()),
        nameFocusNode = FocusNode(),
        percFocusNode = FocusNode();

  final String id;
  final FlavoringOption flavoringOption;
  final TextEditingController nameController;
  final TextEditingController percController;
  final FocusNode nameFocusNode;
  final FocusNode percFocusNode;

  String get name => nameController.text;

  double get ratio => double.parse(percController.text) / 100;

  void dispose() {
    nameController.dispose();
    percController.dispose();
    nameFocusNode.dispose();
    percFocusNode.dispose();
  }
}

class FlavoringEntryRow extends StatelessWidget {
  final FlavoringEntry entry;
  final bool isCustom;
  final VoidCallback? onRemoved;
  final ValueChanged<String>? onNameSubmitted;
  final ValueChanged<String>? onPercentSubmitted;

  FlavoringEntryRow({
    required this.entry,
    this.isCustom = false,
    this.onRemoved,
    this.onNameSubmitted,
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
          child: isCustom
              ? ElTextField(
                  controller: entry.nameController,
                  focusNode: entry.nameFocusNode,
                  contentType: ElTextFieldContentType.text,
                  // labelText: withHeaders ? 'Percentage' : null,
                  suffixText: '%',
                  readOnly: onNameSubmitted == null,
                  onSubmitted: onNameSubmitted,
                )
              : Text(
                  entry.flavoringOption.name,
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
              // labelText: withHeaders ? 'Percentage' : null,
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
              // labelText: withHeaders ? 'VG' : null,
              value: entry.flavoringOption.isVg,
              // onChanged: onIsVGChanged,
            ),
          ),
        ),
      ],
    );
  }
}
