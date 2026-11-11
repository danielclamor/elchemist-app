import 'package:elchemist_app/core/widgets/el_chip.dart';
import 'package:flutter/material.dart';

class ProductionOrderMixChip extends StatelessWidget {
  final IconData? labelIcon;
  final String labelText;
  final Color fgColor;
  final Color bgColor;

  const ProductionOrderMixChip({
    super.key,
    this.labelIcon,
    required this.labelText,
    required this.fgColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElChip(
      labelIcon: Icons.science_rounded,
      labelText: labelText,
      fgColor: fgColor,
      bgColor: bgColor,
    );
  }
}
