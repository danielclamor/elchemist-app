import 'package:elchemist_app/features/formula/domain/formula.dart';
import 'package:elchemist_app/features/formula/presentation/screens/formula_detail_screen.dart';
import 'package:elchemist_app/features/formula/presentation/widgets/pre_mix_chip.dart';
import 'package:flutter/material.dart';

class FormulaListTile extends StatelessWidget {
  final FormulaSummary formula;

  const FormulaListTile({super.key, required this.formula});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 14,
      decorationColor: Colors.grey,
      decorationThickness: 1.0,
    );

    return ListTile(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FormulaDetailScreen(id: formula.id),
        ),
      ),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      minLeadingWidth: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: Row(
          spacing: 4.0,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                formula.name,
                style: textStyle,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  alignment: AlignmentGeometry.centerEnd,
                  child: Text(formula.nicLevel.toString(), style: textStyle)),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: AlignmentGeometry.center,
                child: formula.isPreMix
                    ? PreMixChip(
                        fgColor: Colors.black,
                        bgColor: Colors.grey,
                      )
                    : SizedBox.shrink(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(formula.brand, style: textStyle),
            ),
            Expanded(
              flex: 1,
              child: Text(formula.chillType.toString(), style: textStyle),
            ),
            Expanded(
              flex: 1,
              child: Text(formula.nicType.toString(), style: textStyle),
            ),
          ],
        ),
      ),
    );
  }
}
