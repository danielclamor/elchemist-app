import 'package:flutter/material.dart';

class FormulaListTableHeader extends StatelessWidget {
  final Color? cardColor;

  const FormulaListTableHeader({super.key, this.cardColor});

  @override
  Widget build(BuildContext context) {
    final style = const TextStyle(
      fontSize: 14.0,
    );

    return Card(
      color: cardColor,
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
                Expanded(
                  flex: 2,
                  child: Text("Formula", style: style),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: AlignmentGeometry.centerEnd,
                    child: Text(
                      "Nic Level",
                      style: style,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: AlignmentGeometry.center,
                    child: Text("Premix", style: style),
                  ),
                ),
                Expanded(flex: 1, child: Text("Brand", style: style)),
                Expanded(flex: 1, child: Text("Chill Type", style: style)),
                Expanded(flex: 1, child: Text("Nic Type", style: style)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
