import 'package:elchemist_app/core/widgets/el_chip.dart';
import 'package:flutter/material.dart';

class MixBatchPreMixChip extends StatelessWidget {
  final Color fgColor;
  final Color bgColor;

  const MixBatchPreMixChip({
    super.key,
    required this.fgColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElChip(
      labelIcon: null,
      labelText: "Premix",
      fgColor: fgColor,
      bgColor: bgColor,
    );
  }
}
