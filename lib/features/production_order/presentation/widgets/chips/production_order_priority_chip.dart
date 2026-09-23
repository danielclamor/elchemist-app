import 'package:elchemist_app/core/widgets/el_chip.dart';
import 'package:flutter/material.dart';

class ProductionOrderPriorityChip extends StatelessWidget {
  const ProductionOrderPriorityChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElChip(
      labelIcon: Icons.priority_high_rounded,
      labelText: "Priority",
      fgColor: Colors.grey.shade900,
      bgColor: Colors.red.shade300,
    );
  }
}
