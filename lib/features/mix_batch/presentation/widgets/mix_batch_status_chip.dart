import 'package:elchemist_app/core/widgets/el_chip.dart';
import 'package:elchemist_app/features/mix_batch/domain/mix_batch.dart';
import 'package:flutter/material.dart';

class MixBatchStatusChip extends StatelessWidget {
  final IconData? labelIcon;
  final String labelText;
  final Color fgColor;
  final Color bgColor;

  const MixBatchStatusChip({
    super.key,
    this.labelIcon,
    required this.labelText,
    required this.fgColor,
    required this.bgColor,
  });

  factory MixBatchStatusChip.cancelled({
    String label = 'Cancelled',
  }) =>
      MixBatchStatusChip(
        labelIcon: Icons.remove_circle_outline_rounded,
        labelText: label,
        fgColor: Colors.grey.shade800,
        bgColor: Colors.grey,
      );

  factory MixBatchStatusChip.completed({
    String label = 'Completed',
  }) =>
      MixBatchStatusChip(
        labelIcon: Icons.radio_button_checked_rounded,
        labelText: label,
        fgColor: Colors.grey.shade800,
        bgColor: Colors.grey,
      );

  factory MixBatchStatusChip.inProgress({
    String label = 'In progress',
  }) =>
      MixBatchStatusChip(
        labelIcon: Icons.radio_button_checked_rounded,
        labelText: label,
        fgColor: Colors.blue.shade900,
        bgColor: Colors.blue.shade200,
      );

  factory MixBatchStatusChip.mixed({
    String label = 'Mixed',
  }) =>
      MixBatchStatusChip(
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
