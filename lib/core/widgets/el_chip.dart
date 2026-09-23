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
    return Chip(
      avatar: labelIcon != null
          ? Icon(
              labelIcon,
              color: fgColor,
              size: 12.0,
            )
          : null,
      backgroundColor: bgColor,
      label: Text(
        labelText,
        style: TextStyle(
          color: fgColor,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
          height: 0.0,
        ),
      ),
      labelPadding: EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 8.0,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16.0),
      ),
    );
  }
}
