import 'package:elchemist_app/core/widgets/el_chip.dart';
import 'package:flutter/material.dart';

class ProductionOrderJobChip extends StatelessWidget {
  final IconData? labelIcon;
  final String labelText;
  final Color fgColor;
  final Color bgColor;

  const ProductionOrderJobChip({
    super.key,
    this.labelIcon,
    required this.labelText,
    required this.fgColor,
    required this.bgColor,
  });

  factory ProductionOrderJobChip.unassigned({
    String label = 'Unassigned',
  }) =>
      ProductionOrderJobChip(
        labelIcon: null,
        labelText: label,
        fgColor: Colors.grey.shade800,
        bgColor: Colors.yellow.shade400,
      );

  factory ProductionOrderJobChip.mix({
    String label = 'Mix',
    Color fgColor = Colors.grey,
    Color bgColor = Colors.grey,
  }) =>
      ProductionOrderJobChip(
        labelIcon: Icons.science_rounded,
        labelText: label,
        fgColor: fgColor,
        bgColor: bgColor,
      );

  factory ProductionOrderJobChip.repat({
    String label = 'Streamline',
    Color fgColor = Colors.grey,
    Color bgColor = Colors.grey,
  }) =>
      ProductionOrderJobChip(
        labelIcon: Icons.swap_horiz_rounded,
        labelText: label,
        fgColor: fgColor,
        bgColor: bgColor,
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
