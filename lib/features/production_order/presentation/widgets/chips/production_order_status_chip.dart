import 'package:elchemist_app/core/widgets/el_chip.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
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

  factory ProductionOrderStatusChip.fromStatus({
    required ProductionOrderStatus status,
  }) =>
      switch (status) {
        ProductionOrderStatus.fulfilled => ProductionOrderStatusChip(
            labelIcon: Icons.radio_button_checked_rounded,
            labelText: status.toString(),
            fgColor: Colors.grey.shade800,
            bgColor: Colors.grey,
          ),
        ProductionOrderStatus.inProgress => ProductionOrderStatusChip(
            labelIcon: Icons.timelapse_rounded,
            labelText: status.toString(),
            fgColor: Colors.blue.shade900,
            bgColor: Colors.blue.shade200,
          ),
        ProductionOrderStatus.pending => ProductionOrderStatusChip(
            labelIcon: Icons.radio_button_unchecked_rounded,
            labelText: status.toString(),
            fgColor: Colors.grey.shade800,
            bgColor: Colors.yellow.shade400,
          ),
        ProductionOrderStatus.mixed => ProductionOrderStatusChip(
            labelIcon: Icons.timelapse_rounded,
            labelText: status.toString(),
            fgColor: Colors.blue.shade900,
            bgColor: Colors.blue.shade200,
          ),
        ProductionOrderStatus.pumped => ProductionOrderStatusChip(
            labelIcon: Icons.timelapse_rounded,
            labelText: status.toString(),
            fgColor: Colors.blue.shade900,
            bgColor: Colors.blue.shade200,
          ),
      };

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
