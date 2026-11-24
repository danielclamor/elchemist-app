import 'package:elchemist_app/core/widgets/el_checkbox.dart';
import 'package:elchemist_app/core/widgets/el_text_field.dart';
import 'package:elchemist_app/features/flavoring_option.dart/domain/flavoring_option.dart';
import 'package:elchemist_app/features/recipe/domain/mix_parameters.dart';
import 'package:flutter/material.dart';

class FlavoringEntry {
  FlavoringEntry({
    required this.id,
    this.slug,
    required String name,
    required this.isVg,
    double ratio = 0,
  })  : nameController = TextEditingController(text: name),
        percController = TextEditingController(text: (ratio * 100).toString()),
        nameFocusNode = FocusNode(),
        percFocusNode = FocusNode();

  factory FlavoringEntry.fromOption(FlavoringOption option, {double? ratio}) =>
      FlavoringEntry(
        id: option.id,
        slug: option.slug,
        name: option.name,
        isVg: option.isVg,
        ratio: ratio ?? 0,
      );

  factory FlavoringEntry.fromMixParameters(MixParametersFlavoring f) =>
      FlavoringEntry(
        id: f.id,
        slug: f.slug,
        name: f.name,
        isVg: f.isVg,
        ratio: f.ratio,
      );

  final String id;
  final String? slug;
  final bool isVg;
  final TextEditingController nameController;
  final TextEditingController percController;
  final FocusNode nameFocusNode;
  final FocusNode percFocusNode;

  String get name => nameController.text;

  double get ratio => (double.tryParse(percController.text) ?? 0) / 100;

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
                  suffixText: '%',
                  readOnly: onNameSubmitted == null,
                  onSubmitted: onNameSubmitted,
                )
              : Text(
                  entry.name,
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
              value: entry.isVg,
              // onChanged: onIsVGChanged,
            ),
          ),
        ),
      ],
    );
  }
}
