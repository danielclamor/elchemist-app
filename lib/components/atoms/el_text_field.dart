import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

enum ElTextFieldContentType { text, numeric }

enum ElTextFieldLabelPosition { left, top }

class ElTextField extends StatelessWidget {
  final ElTextFieldLabelPosition? labelPosition;
  final TextEditingController controller;
  final int? decimalPlaces;
  final Widget? label;
  final String? labelText;
  final bool readOnly;
  final ElTextFieldContentType contentType;
  final String? suffixText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TapRegionCallback? onTapOutside;

  const ElTextField({
    super.key,
    required this.controller,
    required this.contentType,
    this.decimalPlaces,
    this.label,
    this.labelText,
    this.labelPosition = ElTextFieldLabelPosition.top,
    this.suffixText,
    this.readOnly = false,
    this.onChanged,
    this.onSubmitted,
    this.onTapOutside,
  });

  int _getDecimalPlaces(double value) {
    if (value == value.toInt()) return 0;

    List<String> parts = value.toString().split('.');

    if (parts.length == 1) return 0;

    int decimalPlaces = parts[1].length;

    if (decimalPlaces.isOdd) {
      decimalPlaces += 1;
    }

    return decimalPlaces > 6
        ? _getDecimalPlaces(double.parse(value.toStringAsFixed(6)))
        : decimalPlaces;
  }

  String _formatNumericalText(String value) {
    if (value == '') return value;

    final valueAsDouble = double.parse(value);

    final decimalPlaces =
        this.decimalPlaces ?? _getDecimalPlaces(valueAsDouble);

    return valueAsDouble.toStringAsFixed(decimalPlaces);
  }

  @override
  Widget build(BuildContext context) {
    if (contentType == ElTextFieldContentType.numeric) {
      controller.text = _formatNumericalText(controller.text);
    }

    final alignment = contentType == ElTextFieldContentType.numeric
        ? TextAlign.end
        : TextAlign.start;

    final keyboardType = contentType == ElTextFieldContentType.numeric
        ? TextInputType.number
        : TextInputType.text;

    final rowLabelAlignment = contentType == ElTextFieldContentType.numeric
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;

    final borderRadius = labelPosition == ElTextFieldLabelPosition.top
        ? const BorderRadius.all(
            Radius.circular(4.0),
          )
        : const BorderRadius.horizontal(
            left: Radius.zero,
            right: Radius.circular(4.0),
          );

    final textField = TextField(
      style: GoogleFonts.robotoMono(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: readOnly ? Theme.of(context).disabledColor : Colors.white,
      ),
      textAlign: alignment,
      readOnly: readOnly,
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTapOutside: onTapOutside,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: Theme.of(context).focusColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: readOnly
              ? BorderSide(color: Theme.of(context).focusColor)
              : const BorderSide(
                  color: Colors.white,
                  width: 1.5,
                ),
        ),
        filled: !readOnly,
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
        suffixIcon: suffixText != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(
                  4.0,
                  12.0,
                  12.0,
                  12.0,
                ),
                child: Text(
                  suffixText ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: readOnly
                        ? Theme.of(context).disabledColor
                        : Colors.white,
                  ),
                ),
              )
            : null,
      ),
    );

    return labelPosition == ElTextFieldLabelPosition.top
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label ??
                  (labelText == null
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: rowLabelAlignment,
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
              Tooltip(
                message: controller.text,
                child: textField,
              ),
            ],
          )
        : Tooltip(
            message: controller.text,
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
                                border: Border(
                                  top: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).focusColor),
                                  bottom: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).focusColor),
                                  left: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).focusColor),
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
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )),
                  Expanded(
                    child: textField,
                  ),
                ],
              ),
            ),
          );
  }
}
