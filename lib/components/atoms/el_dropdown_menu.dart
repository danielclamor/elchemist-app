import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ElDropdownMenu<T> extends StatelessWidget {
  final String label;
  final double? width;
  final bool ignoring;
  final T? initialSelection;
  final UnmodifiableListView<DropdownMenuEntry<T>> dropdownMenuEntries;
  final ValueChanged<T?>? onSelected;

  const ElDropdownMenu({
    super.key,
    this.label = '',
    this.width,
    this.ignoring = true,
    this.initialSelection,
    required this.dropdownMenuEntries,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label == ''
            ? const SizedBox.shrink()
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
        const Gap(2.0),
        IgnorePointer(
          ignoring: ignoring,
          child: DropdownMenu<T>(
            width: width,
            selectOnly: true,
            initialSelection: initialSelection,
            textStyle: GoogleFonts.robotoMonoTextTheme(
              ThemeData(brightness: Brightness.dark).textTheme,
            ).bodyMedium,
            inputDecorationTheme: InputDecorationTheme(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
              filled: !ignoring,
              // contentPadding: const EdgeInsets.symmetric(
              //   vertical: 20.0,
              //   horizontal: 8.0,
              // ),
            ),
            dropdownMenuEntries: dropdownMenuEntries,
            onSelected: onSelected,
          ),
        ),
      ],
    );
  }
}
