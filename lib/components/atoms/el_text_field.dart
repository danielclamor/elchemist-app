import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

enum ContentType { text, numeric }

class ElTextField extends StatelessWidget {
  final String label;
  final String value;
  final bool readOnly;
  final ContentType contentType;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const ElTextField({
    super.key,
    this.label = '',
    required this.value,
    required this.contentType,
    this.prefix,
    this.suffix,
    this.readOnly = false,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final alignment =
        contentType == ContentType.numeric ? TextAlign.end : TextAlign.start;

    final keyboardType = contentType == ContentType.numeric
        ? TextInputType.number
        : TextInputType.text;

    return Column(
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
        Tooltip(
          message: value,
          child: TextField(
            style: GoogleFonts.robotoMonoTextTheme(
              ThemeData(brightness: Brightness.dark).textTheme,
            ).bodyMedium,
            textAlign: alignment,
            readOnly: readOnly,
            controller: TextEditingController(text: value),
            keyboardType: keyboardType,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: readOnly
                    ? const BorderSide()
                    : const BorderSide(
                        color: Colors.white,
                        width: 1.5,
                      ),
              ),
              filled: !readOnly,
              prefix: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: prefix,
              ),
              suffix: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: suffix,
              ),
              // contentPadding: const EdgeInsets.symmetric(
              //   vertical: 16.0,
              //   horizontal: 8.0,
              // ),
            ),
          ),
        ),
      ],
    );
  }
}
