import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/formula/domain/flavoring.dart';
import 'package:flutter/material.dart';

class FormulaDetailFlavoringSection extends StatelessWidget {
  final double? width;
  final List<Flavoring> flavorings;

  const FormulaDetailFlavoringSection({
    super.key,
    this.width,
    required this.flavorings,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      width: width,
      title: 'FLAVOURING',
      child: flavorings.isEmpty
          ? Text(
              'No flavorings',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            )
          : Column(
              children: [
                Row(
                  spacing: 4.0,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        )),
                    Expanded(
                        flex: 4,
                        child: Text(
                          'Percentage',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.right,
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          'VG',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ))
                  ],
                ),
                Column(
                  children: List.generate(flavorings.length, (index) {
                    final flavoring = flavorings[index];
                    return Row(
                      spacing: 4.0,
                      children: [
                        Expanded(
                            flex: 4,
                            child: Text(
                              flavoring.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        Expanded(
                            flex: 4,
                            child: Text(
                              '${flavoring.percentage.toStringAsFixed(2)}%',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.right,
                            )),
                        Expanded(
                            flex: 1,
                            child: Align(
                              alignment: AlignmentGeometry.center,
                              child: ElCheckbox(
                                value: flavoring.isVg,
                              ),
                            ))
                      ],
                    );
                  }),
                ),
              ],
            ),
    );
  }
}
