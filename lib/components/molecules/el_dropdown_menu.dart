import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ElDropdownMenu<T> extends StatelessWidget {
  final Widget? label;
  final String? labelText;
  final double? width;
  final bool enabled;
  final T? initialSelection;
  final UnmodifiableListView<DropdownMenuEntry<T>> dropdownMenuEntries;
  final ValueChanged<T?>? onSelected;

  const ElDropdownMenu({
    super.key,
    this.label,
    this.labelText,
    this.width,
    this.enabled = true,
    this.initialSelection,
    required this.dropdownMenuEntries,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label ??
            (labelText == null
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            labelText ?? '',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Gap(8.0),
                    ],
                  )),
        DropdownMenu<T>(
          enabled: enabled,
          width: width,
          selectOnly: true,
          initialSelection: initialSelection,
          textStyle: GoogleFonts.robotoMono(
            fontSize: 16,
            // color: ignoring ? Theme.of(context).disabledColor : Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).focusColor),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).focusColor),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 1.5,
              ),
            ),
            filled: enabled,
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
          ),
          dropdownMenuEntries: dropdownMenuEntries,
          onSelected: onSelected,
        ),
      ],
    );
  }
}
