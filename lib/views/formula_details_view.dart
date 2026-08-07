import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/organisms/formula_section.dart';
import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/models/nic_profile.dart';
import 'package:elchemist_app/models/formula.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RecipeDetailsView extends StatefulWidget {
  final Formula formula;

  const RecipeDetailsView({
    super.key,
    required this.formula,
  });

  @override
  State<RecipeDetailsView> createState() => _RecipeDetailsViewState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _RecipeDetailsViewState extends State<RecipeDetailsView> {
  NicProfile? _nicProfile;
  List<NicBase> nicBases = [];
  List<Flavoring> flavorings = [];

  int _getDecimalPlaces(double value) {
    if (value == value.toInt()) return 0;
    List<String> parts = value.toString().split('.');

    return parts.length > 1 ? parts[1].length : 0;
  }

  @override
  Widget build(BuildContext context) {
    const sectionWidth = 500.0;
    const cardPadding = EdgeInsetsGeometry.all(24.0);

    final Formula formula = widget.formula;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Recipe",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsetsGeometry.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: sectionWidth),
              child: Column(
                spacing: 8.0,
                children: [
                  FormulaSection(
                    formula: formula,
                    nicProfile: _nicProfile,
                    nicLevelController: TextEditingController(
                        text: _nicProfile == null
                            ? ''
                            : (_nicProfile!.targetNicStr *
                                    (_nicProfile!.isNewMix ? 1000.0 : 250))
                                .toString()),
                    onNicProfileSelected: (value) {
                      if (value == null) return;
                      setState(() {
                        _nicProfile = value;
                      });
                    },
                  ),
                  _nicProfile == null
                      ? const SizedBox.shrink()
                      : Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: cardPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'FLAVOURING',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(20),
                                Column(
                                  spacing: 8.0,
                                  children:
                                      List.generate(flavorings.length, (index) {
                                    final flavoring = flavorings[index];
                                    String? nameLabelText;
                                    String? percentageLabelText;

                                    if (index == 0) {
                                      nameLabelText = 'Name';
                                      percentageLabelText = 'Percentage';
                                    }

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ElTextField(
                                            controller: TextEditingController(
                                              text: flavoring.name,
                                            ),
                                            contentType:
                                                ElTextFieldContentType.text,
                                            readOnly: true,
                                            labelText: nameLabelText,
                                          ),
                                        ),
                                        const Gap(8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints: const BoxConstraints(
                                                maxWidth: 120,
                                              ),
                                              child: ElTextField(
                                                controller:
                                                    TextEditingController(
                                                  text: (flavoring.percentage)
                                                      .toStringAsFixed(4),
                                                ),
                                                contentType:
                                                    ElTextFieldContentType
                                                        .numeric,
                                                readOnly: true,
                                                labelText: percentageLabelText,
                                                suffixText: '%',
                                              ),
                                            ),
                                            const Gap(12.0),
                                            ElCheckbox(
                                              labelText:
                                                  index == 0 ? 'VG' : null,
                                              value: flavoring.isVG,
                                              onChanged: null,
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                  _nicProfile == null
                      ? const SizedBox.shrink()
                      : Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: cardPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'NIC BASE',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(20),
                                ElTextField(
                                  controller: TextEditingController(
                                    text: ((_nicProfile?.nicBaseNicStr ?? 0.0) *
                                            100)
                                        .toStringAsFixed(0),
                                  ),
                                  contentType: ElTextFieldContentType.numeric,
                                  readOnly: true,
                                  labelText: "Nic Str",
                                  labelPosition: ElTextFieldLabelPosition.left,
                                  suffixText: '%',
                                ),
                                const Gap(8),
                                Row(
                                  spacing: 8.0,
                                  children: [
                                    Expanded(
                                      child: ElTextField(
                                        controller: TextEditingController(
                                          text: (nicBases
                                                      .where((nicBase) =>
                                                          nicBase.isVG)
                                                      .fold(
                                                          0.0,
                                                          (sum, nicBase) =>
                                                              sum +
                                                              nicBase.ratio) *
                                                  100)
                                              .toStringAsFixed(0),
                                        ),
                                        contentType:
                                            ElTextFieldContentType.numeric,
                                        readOnly: true,
                                        labelText: 'VG',
                                        labelPosition:
                                            ElTextFieldLabelPosition.left,
                                        suffixText: '%',
                                      ),
                                    ),
                                    Expanded(
                                      child: ElTextField(
                                        controller: TextEditingController(
                                          text: (nicBases
                                                      .where((nicBase) =>
                                                          !nicBase.isVG)
                                                      .fold(
                                                          0.0,
                                                          (sum, nicBase) =>
                                                              sum +
                                                              nicBase.ratio) *
                                                  100)
                                              .toStringAsFixed(0),
                                        ),
                                        contentType:
                                            ElTextFieldContentType.numeric,
                                        readOnly: true,
                                        labelText: 'PG',
                                        labelPosition:
                                            ElTextFieldLabelPosition.left,
                                        suffixText: '%',
                                      ),
                                    ),
                                  ],
                                ),
                                nicBases.isEmpty
                                    ? const SizedBox.shrink()
                                    : Column(
                                        children: [
                                          const Gap(16.0),
                                          const Divider(
                                            thickness: 1,
                                          ),
                                          const Gap(16.0),
                                          Column(
                                            spacing: 8.0,
                                            children: List.generate(
                                                nicBases.length, (index) {
                                              final nicBase = nicBases[index];
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: ElTextField(
                                                      controller:
                                                          TextEditingController(
                                                        text: nicBase.label,
                                                      ),
                                                      contentType:
                                                          ElTextFieldContentType
                                                              .text,
                                                      readOnly: true,
                                                      labelText: index == 0
                                                          ? 'Name'
                                                          : null,
                                                    ),
                                                  ),
                                                  const Gap(8),
                                                  Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                      maxWidth: 120,
                                                    ),
                                                    child: ElTextField(
                                                      controller:
                                                          TextEditingController(
                                                        text: (nicBase.ratio *
                                                                100)
                                                            .toStringAsFixed(0),
                                                      ),
                                                      contentType:
                                                          ElTextFieldContentType
                                                              .numeric,
                                                      readOnly: true,
                                                      labelText: index == 0
                                                          ? 'Percentage'
                                                          : null,
                                                      suffixText: '%',
                                                    ),
                                                  ),
                                                  const Gap(12.0),
                                                  ElCheckbox(
                                                    labelText: index == 0
                                                        ? 'VG'
                                                        : null,
                                                    value: nicBase.isVG,
                                                    onChanged: null,
                                                  ),
                                                ],
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                  _nicProfile == null
                      ? const SizedBox.shrink()
                      : Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: cardPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'TARGET',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(20),
                                ElTextField(
                                  controller: TextEditingController(
                                    text: ((_nicProfile?.targetNicStr ?? 0.0) *
                                            100)
                                        .toStringAsFixed(2),
                                  ),
                                  contentType: ElTextFieldContentType.numeric,
                                  readOnly: true,
                                  labelText: "Nic Str",
                                  labelPosition: ElTextFieldLabelPosition.left,
                                  suffixText: '%',
                                ),
                                const Gap(8),
                                Row(
                                  spacing: 8.0,
                                  children: [
                                    Expanded(
                                      child: ElTextField(
                                        controller: TextEditingController(
                                          text: ((_nicProfile?.targetVG ??
                                                      0.0) *
                                                  100)
                                              .toStringAsFixed(_getDecimalPlaces(
                                                              _nicProfile
                                                                      ?.targetVG ??
                                                                  0.0) -
                                                          2 >
                                                      4
                                                  ? _getDecimalPlaces(
                                                          _nicProfile
                                                                  ?.targetVG ??
                                                              0.0) -
                                                      2
                                                  : 4),
                                        ),
                                        contentType:
                                            ElTextFieldContentType.numeric,
                                        readOnly: true,
                                        labelText: 'VG',
                                        labelPosition:
                                            ElTextFieldLabelPosition.left,
                                        suffixText: '%',
                                      ),
                                    ),
                                    Expanded(
                                      child: ElTextField(
                                        controller: TextEditingController(
                                          text: ((_nicProfile?.targetPG ??
                                                      0.0) *
                                                  100)
                                              .toStringAsFixed(_getDecimalPlaces(
                                                              _nicProfile
                                                                      ?.targetPG ??
                                                                  0.0) -
                                                          2 >
                                                      4
                                                  ? _getDecimalPlaces(
                                                          _nicProfile
                                                                  ?.targetPG ??
                                                              0.0) -
                                                      2
                                                  : 4),
                                        ),
                                        contentType:
                                            ElTextFieldContentType.numeric,
                                        readOnly: true,
                                        labelText: 'PG',
                                        labelPosition:
                                            ElTextFieldLabelPosition.left,
                                        suffixText: '%',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
