import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SectionCard extends StatelessWidget {
  final double? width;
  final String? title;
  final Widget child;

  const SectionCard({
    super.key,
    this.width,
    this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            4.0,
          ),
        ),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title != null
                  ? Text(
                      title!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const SizedBox.shrink(),
              const Gap(24),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
