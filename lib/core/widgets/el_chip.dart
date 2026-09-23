import 'package:flutter/material.dart';

class ElChip extends StatelessWidget {
  final IconData? labelIcon;
  final String labelText;
  final Color fgColor;
  final Color bgColor;

  const ElChip({
    super.key,
    this.labelIcon,
    required this.labelText,
    required this.fgColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      labelText,
      style: TextStyle(
        color: fgColor,
        fontWeight: FontWeight.bold,
        fontSize: 12.0,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(24.0),
        color: bgColor,
      ),
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
      child: labelIcon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 4.0,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    labelIcon,
                    color: fgColor,
                    size: 12.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 0.0,
                    right: 12.0,
                  ),
                  child: text,
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 12.0,
              ),
              child: text,
            ),
    );
  }
}
