import 'package:elchemist_app/constants.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/models/formula.dart';
import 'package:flutter/material.dart';

class NicBaseEntry {
  NicBaseEntry({
    NicBase? nicBase,
    bool? isVG,
  })  : id = UniqueKey(),
        nicBase = nicBase,
        percentageController = TextEditingController(
          text: ((nicBase?.percentage ?? 0.0) * 100).toStringAsFixed(0),
        ),
        isVG = isVG ?? false;

  final Key id;
  final NicBase? nicBase;
  final TextEditingController percentageController;
  final FocusNode percentageFocusNode = FocusNode();
  bool isVG;

  void dispose() {
    percentageController.dispose();
    percentageFocusNode.dispose();
  }

  String get code => nicBase?.code ?? '';
}

class MixView extends StatefulWidget {
  final Formula formula;

  const MixView({
    super.key,
    required this.formula,
  });

  @override
  State<MixView> createState() => _MixViewState();
}

class _MixViewState extends State<MixView> {
  final List<NicBaseOption> _nicBaseOptions = nicBaseOptionsData
      .map((option) => NicBaseOption.fromMap(option))
      .toList();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
