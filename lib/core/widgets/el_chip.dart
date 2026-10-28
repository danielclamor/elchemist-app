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

    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 4.0,
          children: [
            if (labelIcon != null)
              Icon(
                labelIcon,
                color: fgColor,
                size: 12.0,
              ),
            text,
          ],
        ),
      ),
    );
  }
}
