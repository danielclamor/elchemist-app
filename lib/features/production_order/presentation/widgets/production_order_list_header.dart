import 'package:flutter/material.dart';

class ProductionOrderListHeader extends StatelessWidget {
  const ProductionOrderListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final style = const TextStyle(
      fontSize: 14.0,
    );

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(0, 4),
          ),
        ],
        border: Border(
          bottom: BorderSide(
            width: 0.25,
          ),
        ),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0.0,
        shape: RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            spacing: 12.0,
            children: [
              Row(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
