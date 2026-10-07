import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

typedef PageIndexRange = ({int first, int last});

class ProductionOrderListFooter extends StatelessWidget {
  final PageIndexRange? range;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final Color? cardColor;

  const ProductionOrderListFooter({
    super.key,
    required this.range,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.onPrevious,
    required this.onNext,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final fgColor = Theme.of(context).colorScheme.onInverseSurface;
    final bgColor = Theme.of(context).colorScheme.inverseSurface;

    return Card(
      color: cardColor,
      margin: EdgeInsets.zero,
      elevation: 0.0,
      shape: RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            SizedBox(
              width: 30,
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
                onPressed: hasPreviousPage ? onPrevious : null,
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
              ),
            ),
            Gap(4.0),
            SizedBox(
              width: 30,
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
                onPressed: hasNextPage ? onNext : null,
                child: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              ),
            ),
            Gap(8.0),
            Text(range != null ? '${range?.first}-${range?.last}' : ''),
          ],
        ),
      ),
    );
  }
}
