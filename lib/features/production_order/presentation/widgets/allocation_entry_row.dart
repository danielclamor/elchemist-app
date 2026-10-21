import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/features/location/domain/location.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AllocationEntry {
  AllocationEntry({
    required this.location,
    int? quantity,
  })  : id = location.id,
        controller = TextEditingController(text: quantity?.toString()),
        focusNode = FocusNode();

  final String id;
  final LocationSummary location;
  final TextEditingController controller;
  final FocusNode focusNode;

  int get quantity => int.tryParse(controller.text) ?? 0;

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}

class AllocationEntryRow extends StatelessWidget {
  final AllocationEntry entry;
  final ValueChanged<String>? onQuantitySubmitted;
  final VoidCallback? onRemoved;

  AllocationEntryRow({
    required this.entry,
    this.onQuantitySubmitted,
    this.onRemoved,
  }) : super(key: ValueKey(entry.id));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            entry.location.name,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Gap(16.0),
        SizedBox(
          width: 100,
          child: ElTextField(
            controller: entry.controller,
            focusNode: entry.focusNode,
            contentType: ElTextFieldContentType.numeric,
            onSubmitted: onQuantitySubmitted,
          ),
        ),
        const Gap(8.0),
        SizedBox(
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
        ),
      ],
    );
  }
}
