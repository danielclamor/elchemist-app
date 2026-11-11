import 'package:flutter/material.dart';

class MixSessionListTableHeader extends StatelessWidget {
  final Color? cardColor;

  const MixSessionListTableHeader({
    super.key,
    this.cardColor,
  });

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
                Expanded(flex: 2, child: Text("Mix Session", style: style)),
                Expanded(flex: 4, child: Text("Formula", style: style)),
                Expanded(flex: 2, child: Text("Date", style: style)),
                Expanded(flex: 1, child: Text("Status", style: style)),
                Expanded(flex: 2, child: Text("Mixed at", style: style)),
                Expanded(flex: 2, child: Text("Batch Code", style: style)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
