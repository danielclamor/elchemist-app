import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:flutter/material.dart';

class NicBaseEntry {
  NicBaseEntry({
    NicBase? nicBase,
  })  : id = UniqueKey(),
        nicBase = nicBase,
        percentageController = TextEditingController(
          text: ((nicBase?.percentage ?? 0.0) * 100).toStringAsFixed(0),
        );

  final Key id;
  NicBase? nicBase;
  final TextEditingController percentageController;

  void dispose() {
    percentageController.dispose();
  }

  bool get isVG => nicBase?.isVG ?? false;

  String get code => nicBase?.code ?? '';

  double get ratio => double.parse(percentageController.text) / 100;
}

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
