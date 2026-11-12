import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/formula/presentation/widgets/formula_detail_flavoring_section.dart';
import 'package:elchemist_app/features/formula/presentation/widgets/formula_detail_nic_base_section.dart';
import 'package:elchemist_app/features/formula/presentation/widgets/formula_detail_target_section.dart';
import 'package:elchemist_app/features/formula/providers/formula_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class FormulaDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const FormulaDetailScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<FormulaDetailScreen> createState() =>
      _FormulaDetailScreenState();
}

class _FormulaDetailScreenState extends ConsumerState<FormulaDetailScreen> {
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
    final async = ref.watch(formulaDetailsProvider(widget.id));

    var screenSize = MediaQuery.of(context).size;
    var wrapperWidth = screenSize.width < 1920 ? 800.0 : 1000.0;
    var sectionWidth = 500.0;
    var recipeSectionWidth =
        screenSize.width < 1920 ? sectionWidth : sectionWidth + 250;

    final formula = async.when(
      error: (error, stackTrace) => null,
      loading: () => null,
      data: (data) => data,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            constraints: BoxConstraints(),
            child: Column(
              children: [
                Row(
                  spacing: 8.0,
                  children: [
                    Tooltip(
                      message: "Formulas",
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            shape: const CircleBorder(),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Formulas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Gap(16.0),
                Container(
                  constraints: BoxConstraints(maxWidth: wrapperWidth),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Container(
                              constraints:
                                  BoxConstraints(maxWidth: sectionWidth),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      formula?.name ?? '',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(16.0),
                            if (formula != null)
                              FormulaDetailFlavoringSection(
                                width: sectionWidth,
                                flavorings: formula.flavorings,
                              ),
                            Gap(16.0),
                            if (formula != null)
                              FormulaDetailNicBaseSection(
                                width: sectionWidth,
                                nicBases: formula.nicBases,
                                nicStr: formula.nicBaseNicStr,
                                vg: formula.nicBaseVg,
                                pg: formula.nicBasePg,
                              ),
                            Gap(16.0),
                            if (formula != null)
                              FormulaDetailTargetSection(
                                width: sectionWidth,
                                nicStr: formula.targetNicStr,
                                vg: formula.targetVg,
                                pg: formula.targetPg,
                              )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Column(
                              spacing: 4.0,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nicotine Level',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      4.0,
                                    ),
                                  ),
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 12.0,
                                    ),
                                    child: SizedBox(
                                      width: 300,
                                      child: formula != null
                                          ? Text(
                                              '${_formatNumericalText(formula.nicLevel.toString())} mg',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap(20.0),
                            Column(
                              spacing: 4.0,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Brand',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      4.0,
                                    ),
                                  ),
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 12.0,
                                    ),
                                    child: SizedBox(
                                      width: 300,
                                      child: Text(
                                        formula?.brand ?? '',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap(20.0),
                            Column(
                              spacing: 4.0,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chill Type',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      4.0,
                                    ),
                                  ),
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 12.0,
                                    ),
                                    child: SizedBox(
                                      width: 300,
                                      child: Text(
                                        formula?.chillType.toString() ?? '',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap(20.0),
                            Column(
                              spacing: 4.0,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nicotine Type',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      4.0,
                                    ),
                                  ),
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 12.0,
                                    ),
                                    child: SizedBox(
                                      width: 300,
                                      child: Text(
                                        formula?.nicType.toString() ?? '',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
