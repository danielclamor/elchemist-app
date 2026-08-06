import 'package:collection/collection.dart';
import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/el_dropdown_menu.dart';
import 'package:elchemist_app/constants.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NicBaseEntry {
  NicBaseEntry({
    NicBase? nicBase,
  })  : id = UniqueKey(),
        nicBase = nicBase,
        percentageController = TextEditingController(
          text: ((nicBase?.percentage ?? 0.0) * 100).toStringAsFixed(0),
        );

  final Key id;
  NicBase? nicBase;
  final TextEditingController percentageController;

  void dispose() {
    percentageController.dispose();
  }

  bool get isVG => nicBase?.isVG ?? false;

  String get code => nicBase?.code ?? '';

  double get ratio => double.parse(percentageController.text) / 100;
}

class NicBaseEntryRow extends StatelessWidget {
  final NicBaseEntry entry;
  final bool isCustom;
  final bool withHeaders;
  final bool showDeleteIcon;
  final VoidCallback? onEntryDeleted;
  final ValueChanged<NicBaseOption?>? onOptionSelected;
  final ValueChanged<String>? onPercentSubmitted;

  const NicBaseEntryRow({
    super.key,
    required this.entry,
    required this.isCustom,
    required this.withHeaders,
    required this.showDeleteIcon,
    this.onEntryDeleted,
    this.onOptionSelected,
    this.onPercentSubmitted,
  });

  List<NicBaseOption> get _nicBaseOptions => nicBaseOptionsData
      .map((option) => NicBaseOption.fromMap(option))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showDeleteIcon
            ? Padding(
                padding: EdgeInsets.only(top: withHeaders ? 28.0 : 4.0),
                child: IconButton(
                  onPressed: onEntryDeleted,
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => ElDropdownMenu<NicBaseOption>(
              width: constraints.maxWidth,
              ignoring: !isCustom,
              initialSelection: _nicBaseOptions.firstWhereOrNull(
                (option) => option == entry.nicBase?.nicBaseOption,
              ),
              labelText: withHeaders ? 'Name' : null,
              dropdownMenuEntries:
                  UnmodifiableListView<DropdownMenuEntry<NicBaseOption>>(
                _nicBaseOptions.map<DropdownMenuEntry<NicBaseOption>>(
                  (option) => DropdownMenuEntry<NicBaseOption>(
                    value: option,
                    label: option.label,
                  ),
                ),
              ),
              onSelected: onOptionSelected,
            ),
          ),
        ),
        const Gap(8),
        Container(
          constraints: const BoxConstraints(maxWidth: 120),
          child: ElTextField(
            controller: entry.percentageController,
            contentType: ElTextFieldContentType.numeric,
            labelText: withHeaders ? 'Percentage' : null,
            readOnly: !isCustom,
            suffix: const Text("%"),
            onSubmitted: onPercentSubmitted,
          ),
        ),
        const Gap(12.0),
        ElCheckbox(
          labelText: withHeaders ? 'VG' : null,
          value: entry.isVG,
        ),
      ],
    );
  }
}
