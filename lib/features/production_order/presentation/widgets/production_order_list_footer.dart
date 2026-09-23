import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductionOrderListFooter extends StatelessWidget {
  final int firstIndex;
  final int lastIndex;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const ProductionOrderListFooter({
    super.key,
    required this.firstIndex,
    required this.lastIndex,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  @override
  Widget build(BuildContext context) {
    final fgColor = Theme.of(context).colorScheme.onInverseSurface;
    final bgColor = Theme.of(context).colorScheme.inverseSurface;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.0,
      shape: RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            SizedBox(
              width: 30, // Match width and height for a perfect square
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: fgColor,
                  backgroundColor: bgColor,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                    ),
                  ),
                ),
                onPressed: hasPreviousPage ? () {} : null,
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
              ),
            ),
            Gap(4.0),
            SizedBox(
              width: 30, // Match width and height for a perfect square
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: fgColor,
                  backgroundColor: bgColor,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                ),
                onPressed: hasNextPage ? () {} : null,
                child: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              ),
            ),
            Gap(8.0),
            Text("$firstIndex-$lastIndex"),
          ],
        ),
      ),
    );
  }
}
