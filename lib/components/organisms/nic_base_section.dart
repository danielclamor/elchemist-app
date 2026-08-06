import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:flutter/material.dart';

class NicBaseSection extends StatelessWidget {
  final double? width;
  final Widget child;

  const NicBaseSection({
    super.key,
    this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      width: width,
      title: "NIC BASE",
      child: child,
    );
  }
}
