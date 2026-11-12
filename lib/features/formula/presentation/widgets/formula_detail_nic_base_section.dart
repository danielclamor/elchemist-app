import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/section_card.dart';
import 'package:elchemist_app/features/formula/domain/nic_base.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FormulaDetailNicBaseSection extends StatelessWidget {
  final double? width;
  final double nicStr;
  final double vg;
  final double pg;
  final List<NicBase> nicBases;

  const FormulaDetailNicBaseSection({
    super.key,
    this.width,
    required this.nicBases,
    required this.nicStr,
    required this.vg,
    required this.pg,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      width: width,
      title: 'NIC BASE',
      child: nicBases.isEmpty
          ? Text(
              'No nic bases',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            )
          : Column(
              children: [
                ElTextField(
                  controller:
                      TextEditingController(text: (nicStr * 100).toString()),
                  contentType: ElTextFieldContentType.numeric,
                  labelText: 'Nic Str',
                  labelPosition: ElTextFieldLabelPosition.left,
                  readOnly: true,
                  suffixText: '%',
                  onSubmitted: (value) {},
                ),
                const Gap(8.0),
                Row(
                  spacing: 8.0,
                  children: [
                    Expanded(
                      child: ElTextField(
                        controller:
                            TextEditingController(text: (vg * 100).toString()),
                        contentType: ElTextFieldContentType.numeric,
                        labelText: 'VG',
                        labelPosition: ElTextFieldLabelPosition.left,
                        readOnly: true,
                        suffixText: '%',
                        onSubmitted: (value) {},
                      ),
                    ),
                    Expanded(
                      child: ElTextField(
                        controller:
                            TextEditingController(text: (pg * 100).toString()),
                        contentType: ElTextFieldContentType.numeric,
                        labelText: 'PG',
                        labelPosition: ElTextFieldLabelPosition.left,
                        readOnly: true,
                        suffixText: '%',
                        onSubmitted: (value) {},
                      ),
                    ),
                  ],
                ),
                Gap(16.0),
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
                  children: List.generate(nicBases.length, (index) {
                    final nicBase = nicBases[index];
                    return Row(
                      spacing: 4.0,
                      children: [
                        Expanded(
                            flex: 4,
                            child: Text(
                              nicBase.label,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        Expanded(
                            flex: 4,
                            child: Text(
                              '${nicBase.percentage.toStringAsFixed(2)}%',
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
                                value: nicBase.isVg,
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
