import 'package:flutter/material.dart';

class ProductionOrderHeaderRow extends StatelessWidget {
  const ProductionOrderHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    final style = const TextStyle(
      fontSize: 12.0,
    );

    return Row(
      spacing: 4.0,
      children: [
        Expanded(flex: 2, child: Text("Order", style: style)),
        Expanded(flex: 3, child: Text("E-liquid", style: style)),
        Expanded(flex: 1, child: Text("Ordered", style: style)),
        Expanded(flex: 1, child: Text("Fulfilled", style: style)),
        Expanded(flex: 2, child: Text("Date", style: style)),
        Expanded(flex: 1, child: Text("Assigned to", style: style)),
        Expanded(flex: 1, child: Text("Status", style: style)),
        Expanded(flex: 1, child: SizedBox.shrink()),
      ],
    );
  }
}
