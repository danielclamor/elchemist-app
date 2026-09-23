import 'package:elchemist_app/core/widgets/el_chip.dart';
import 'package:flutter/material.dart';

class ProductionOrderStatusChip extends StatelessWidget {
  final IconData? labelIcon;
  final String labelText;
  final Color fgColor;
  final Color bgColor;

  const ProductionOrderStatusChip({
    super.key,
    required this.labelIcon,
    required this.labelText,
    required this.fgColor,
    required this.bgColor,
  });

  factory ProductionOrderStatusChip.cancelled({
    String label = 'Cancelled',
  }) =>
      ProductionOrderStatusChip(
        labelIcon: Icons.radio_button_unchecked_rounded,
        labelText: label,
        fgColor: Colors.grey.shade800,
        bgColor: Colors.grey,
      );

  factory ProductionOrderStatusChip.delivered({
    String label = 'Delivered',
  }) =>
      ProductionOrderStatusChip(
        labelIcon: Icons.radio_button_checked_rounded,
        labelText: label,
        fgColor: Colors.grey.shade800,
        bgColor: Colors.grey,
      );

  factory ProductionOrderStatusChip.fulfilled({
    String label = 'Fulfilled',
  }) =>
      ProductionOrderStatusChip(
        labelIcon: Icons.radio_button_checked_rounded,
        labelText: label,
        fgColor: Colors.green.shade900,
        bgColor: Colors.green.shade300,
      );

  factory ProductionOrderStatusChip.inProgress({
    String label = 'In progress',
  }) =>
      ProductionOrderStatusChip(
        labelIcon: Icons.timelapse_rounded,
        labelText: label,
        fgColor: Colors.blue.shade900,
        bgColor: Colors.blue.shade200,
      );

  factory ProductionOrderStatusChip.pending({
    String label = 'Pending',
  }) =>
      ProductionOrderStatusChip(
        labelIcon: Icons.radio_button_unchecked_rounded,
        labelText: label,
        fgColor: Colors.grey.shade800,
        bgColor: Colors.yellow.shade400,
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
