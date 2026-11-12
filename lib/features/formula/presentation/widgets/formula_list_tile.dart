import 'package:elchemist_app/features/formula/domain/formula.dart';
import 'package:elchemist_app/features/formula/presentation/screens/formula_detail_screen.dart';
import 'package:elchemist_app/features/formula/presentation/widgets/pre_mix_chip.dart';
import 'package:flutter/material.dart';

class FormulaListTile extends StatelessWidget {
  final FormulaSummary formula;

  const FormulaListTile({super.key, required this.formula});

  int _getDecimalPlaces(double value) {
    if (value == value.toInt()) return 0;

    List<String> parts = value.toString().split('.');

    if (parts.length == 1) return 0;

    int decimalPlaces = parts[1].length;

    if (decimalPlaces.isOdd) {
      decimalPlaces += 1;
    }

    return decimalPlaces > 6
        ? _getDecimalPlaces(double.parse(value.toStringAsFixed(6)))
        : decimalPlaces;
  }

  String _formatNumericalText(String value) {
    if (value == '') return value;

    final valueAsDouble = double.parse(value);

    final decimalPlaces = _getDecimalPlaces(valueAsDouble);

    return valueAsDouble.toStringAsFixed(decimalPlaces);
  }

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
                  child: Text(
                    '${_formatNumericalText(formula.nicLevel.toString())} mg',
                    style: textStyle,
                  )),
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
