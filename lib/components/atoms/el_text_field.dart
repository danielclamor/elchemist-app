import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

enum ElTextFieldContentType { text, numeric }

enum ElTextFieldLabelPosition { left, top }

class ElTextField extends StatelessWidget {
  final Widget? label;
  final String? labelText;
  final ElTextFieldLabelPosition? labelPosition;
  final String value;
  final bool readOnly;
  final ElTextFieldContentType contentType;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const ElTextField({
    super.key,
    this.label,
    this.labelText,
    this.labelPosition = ElTextFieldLabelPosition.top,
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
    final alignment = contentType == ElTextFieldContentType.numeric
        ? TextAlign.end
        : TextAlign.start;

    final keyboardType = contentType == ElTextFieldContentType.numeric
        ? TextInputType.number
        : TextInputType.text;

    final rowLabelAlignment = contentType == ElTextFieldContentType.numeric
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;

    return labelPosition == ElTextFieldLabelPosition.top
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label ??
                  (labelText == null
                      ? const SizedBox.shrink()
                      : Row(
                          mainAxisAlignment: rowLabelAlignment,
                          children: [
                            Padding(
                              padding:
                                  contentType == ElTextFieldContentType.numeric
                                      ? const EdgeInsets.only(right: 8.0)
                                      : const EdgeInsets.only(left: 8.0),
                              child: Text(
                                labelText ?? '',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        )),
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
                    prefixIcon: prefix != null
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(
                              12.0,
                              12.0,
                              4.0,
                              12.0,
                            ),
                            child: prefix,
                          )
                        : null,
                    suffixIcon: suffix != null
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(
                              4.0,
                              12.0,
                              12.0,
                              12.0,
                            ),
                            child: suffix,
                          )
                        : null,
                  ),
                ),
              ),
            ],
          )
        : Tooltip(
            message: value,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  label ??
                      (labelText == null
                          ? const SizedBox.shrink()
                          : Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                border: const Border(
                                  top: BorderSide(width: 1.0),
                                  bottom: BorderSide(width: 1.0),
                                  left: BorderSide(width: 1.0),
                                  right: BorderSide.none,
                                ),
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(4.0),
                                  right: Radius.zero,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12.0,
                                  12.0,
                                  8.0,
                                  12.0,
                                ),
                                child: Text(
                                  labelText ?? '',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            )),
                  Expanded(
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
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.zero,
                            right: Radius.circular(4.0),
                          ),
                          borderSide: BorderSide(),
                        ),
                        disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.zero,
                            right: Radius.circular(4.0),
                          ),
                          borderSide: readOnly
                              ? const BorderSide()
                              : const BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                        ),
                        filled: !readOnly,
                        prefixIcon: prefix != null
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12.0,
                                  12.0,
                                  4.0,
                                  12.0,
                                ),
                                child: prefix,
                              )
                            : null,
                        suffixIcon: suffix != null
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  4.0,
                                  12.0,
                                  12.0,
                                  12.0,
                                ),
                                child: suffix,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
