import 'package:collection/collection.dart';
import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/el_dropdown_menu.dart';
import 'package:elchemist_app/features/formula/domain/nic_base.dart';
import 'package:elchemist_app/features/nic_base_option/domain/nic_base_option.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NicBaseEntry {
  NicBaseEntry({
    required this.nicBaseOption,
    double? ratio,
  })  : id = nicBaseOption.code,
        controller = TextEditingController(
            text: ratio != null ? (ratio * 100).toString() : ""),
        focusNode = FocusNode();

  final String id;
  final NicBaseOption nicBaseOption;
  final TextEditingController controller;
  final FocusNode focusNode;

  double get ratio => (int.tryParse(controller.text) ?? 0) / 100;

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}

class NicBaseEntryRow extends StatelessWidget {
  final NicBaseEntry entry;
  final bool isCustom;
  // final bool withHeaders;
  // final bool showDeleteIcon;
  // final VoidCallback? onEntryDeleted;
  // final ValueChanged<NicBaseOption?>? onOptionSelected;
  final VoidCallback? onRemoved;
  final ValueChanged<String>? onPercentSubmitted;

  NicBaseEntryRow({
    required this.entry,
    this.isCustom = false,
    // required this.withHeaders,
    // required this.showDeleteIcon,
    // this.onEntryDeleted,
    // this.onOptionSelected,
    this.onRemoved,
    this.onPercentSubmitted,
  }) : super(key: ValueKey(entry.id));

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.0,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // showDeleteIcon
        //     ? Padding(
        //         padding: EdgeInsets.only(top: withHeaders ? 28.0 : 4.0),
        //         child: IconButton(
        //           onPressed: onEntryDeleted,
        //           icon: const Icon(
        //             Icons.delete,
        //           ),
        //         ),
        //       )
        //     : const SizedBox.shrink(),
        // Expanded(
        //   child: LayoutBuilder(
        //     builder: (context, constraints) => ElDropdownMenu<NicBaseOption>(
        //       width: constraints.maxWidth,
        //       enabled: isCustom,
        //       initialSelection: entry.option,
        //       labelText: withHeaders ? 'Name' : null,
        //       dropdownMenuEntries:
        //           UnmodifiableListView<DropdownMenuEntry<NicBaseOption>>(
        //         nicBaseOptions.map<DropdownMenuEntry<NicBaseOption>>(
        //           (option) => DropdownMenuEntry<NicBaseOption>(
        //             value: option,
        //             label: option.label,
        //           ),
        //         ),
        //       ),
        //       onSelected: onOptionSelected,
        //     ),
        //   ),
        // ),
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
            entry.nicBaseOption.label,
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
          child: SizedBox(
            width: 100,
            child: ElTextField(
              controller: entry.controller,
              focusNode: entry.focusNode,
              contentType: ElTextFieldContentType.numeric,
              // labelText: 'Percentage',
              suffixText: '%',
              readOnly: !isCustom,
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
              value: entry.nicBaseOption.isVg,
            ),
          ),
        ),
      ],
    );
  }
}
