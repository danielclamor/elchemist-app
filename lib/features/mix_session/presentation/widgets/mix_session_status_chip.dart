import 'package:elchemist_app/core/widgets/el_chip.dart';
import 'package:flutter/material.dart';

class MixSessionStatusChip extends StatelessWidget {
  final IconData? labelIcon;
  final String labelText;
  final Color fgColor;
  final Color bgColor;

  const MixSessionStatusChip({
    super.key,
    this.labelIcon,
    required this.labelText,
    required this.fgColor,
    required this.bgColor,
  });

  factory MixSessionStatusChip.cancelled({
    String label = 'Cancelled',
  }) =>
      MixSessionStatusChip(
        labelIcon: Icons.remove_circle_outline_rounded,
        labelText: label,
        fgColor: Colors.grey.shade800,
        bgColor: Colors.grey,
      );

  factory MixSessionStatusChip.completed({
    String label = 'Completed',
  }) =>
      MixSessionStatusChip(
        labelIcon: Icons.radio_button_checked_rounded,
        labelText: label,
        fgColor: Colors.grey.shade800,
        bgColor: Colors.grey,
      );

  factory MixSessionStatusChip.inProgress({
    String label = 'In progress',
  }) =>
      MixSessionStatusChip(
        labelIcon: Icons.radio_button_checked_rounded,
        labelText: label,
        fgColor: Colors.blue.shade900,
        bgColor: Colors.blue.shade200,
      );

  factory MixSessionStatusChip.mixed({
    String label = 'Mixed',
  }) =>
      MixSessionStatusChip(
        labelIcon: Icons.radio_button_checked_rounded,
        labelText: label,
        fgColor: Colors.green.shade900,
        bgColor: Colors.green.shade200,
      );

  @override
  Widget build(BuildContext context) {
    return ElChip(
      labelIcon: labelIcon,
      labelText: labelText,
      fgColor: fgColor,
      bgColor: bgColor,
    );
  }
}
