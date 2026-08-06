import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FlavoringEntry {
  FlavoringEntry({
    String? name,
    double? ratio,
    bool? isVG,
  })  : id = UniqueKey(),
        nameController = TextEditingController(text: name),
        percentageController =
            TextEditingController(text: ((ratio ?? 0) * 100).toString());

  final Key id;
  final TextEditingController nameController;
  final TextEditingController percentageController;
  bool isVG = false;

  void dispose() {
    nameController.dispose();
    percentageController.dispose();
  }

  String? get name => nameController.text;

  double get ratio => double.parse(percentageController.text) / 100;
}

class FlavoringEntryRow extends StatelessWidget {
  final FlavoringEntry entry;
  final bool withHeaders;
  final bool showDeleteIcon;
  final VoidCallback? onEntryDeleted;
  final ValueChanged<String>? onNameSubmitted;
  final ValueChanged<String>? onPercentSubmitted;
  final ValueChanged<bool?>? onIsVGChanged;

  FlavoringEntryRow({
    required this.entry,
    required this.withHeaders,
    required this.showDeleteIcon,
    this.onEntryDeleted,
    this.onNameSubmitted,
    this.onPercentSubmitted,
    this.onIsVGChanged,
  }) : super(key: entry.id);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      key: entry.id,
      children: [
        showDeleteIcon
            ? Padding(
                padding: EdgeInsets.only(top: withHeaders ? 28.0 : 4.0),
                child: IconButton(
                  onPressed: onEntryDeleted,
                  icon: const Icon(Icons.delete),
                ),
              )
            : const SizedBox.shrink(),
        Expanded(
          child: ElTextField(
            controller: entry.nameController,
            contentType: ElTextFieldContentType.text,
            labelText: withHeaders ? 'Name' : null,
            readOnly: onNameSubmitted == null,
            onSubmitted: onNameSubmitted,
          ),
        ),
        const Gap(8.0),
        Container(
          constraints: const BoxConstraints(maxWidth: 120),
          child: ElTextField(
            controller: entry.percentageController,
            contentType: ElTextFieldContentType.numeric,
            labelText: withHeaders ? 'Percentage' : null,
            suffixText: '%',
            readOnly: onPercentSubmitted == null,
            onSubmitted: onPercentSubmitted,
          ),
        ),
        const Gap(12.0),
        ElCheckbox(
          labelText: withHeaders ? 'VG' : null,
          value: entry.isVG,
          onChanged: onIsVGChanged,
        ),
      ],
    );
  }
}
