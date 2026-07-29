import 'dart:collection';

import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/components/atoms/el_dropdown_menu.dart';
import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/models/nic_profile.dart';
import 'package:elchemist_app/models/formula.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RecipeDetailsView extends StatefulWidget {
  final Formula recipe;

  const RecipeDetailsView({
    super.key,
    required this.recipe,
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

    final Formula recipe = widget.recipe;

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
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        4.0,
                      ),
                    ),
                    elevation: 0.0,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                recipe.brand.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                recipe.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${recipe.nicType.toString()} — ${recipe.chilltype.toString()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Gap(24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            spacing: 8,
                            children: [
                              Expanded(
                                child: LayoutBuilder(
                                  builder: (context, constraints) =>
                                      ElDropdownMenu<NicProfile>(
                                    width: constraints.maxWidth,
                                    labelText: 'Profile',
                                    initialSelection: _nicProfile,
                                    ignoring: false,
                                    dropdownMenuEntries: UnmodifiableListView<
                                        DropdownMenuEntry<NicProfile>>(
                                      recipe.nicProfiles
                                          .map<DropdownMenuEntry<NicProfile>>(
                                        (nicProfile) =>
                                            DropdownMenuEntry<NicProfile>(
                                          value: nicProfile,
                                          label:
                                              '${nicProfile.nicLevel} (${nicProfile.newMixLabel})',
                                        ),
                                      ),
                                    ),
                                    onSelected: (NicProfile? value) {
                                      setState(() {
                                        _nicProfile = value;

                                        nicBases = _nicProfile!.nicBases;
                                        flavorings = _nicProfile!.flavorings;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 155,
                                child: _nicProfile == null
                                    ? const SizedBox()
                                    : ElTextField(
                                        value: ((_nicProfile?.targetNicStr ??
                                                    0.0) *
                                                100)
                                            .toStringAsFixed(2),
                                        readOnly: true,
                                        contentType:
                                            ElTextFieldContentType.numeric,
                                        labelText: 'Nic Str',
                                        // labelPosition:
                                        //     ElTextFieldLabelPosition.left,
                                        suffix: const Text('%'),
                                      ),
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
                                            readOnly: true,
                                            value: flavoring.name,
                                            contentType:
                                                ElTextFieldContentType.text,
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
                                                readOnly: true,
                                                value:
                                                    (flavoring.percentage * 100)
                                                        .toStringAsFixed(4),
                                                contentType:
                                                    ElTextFieldContentType
                                                        .numeric,
                                                labelText: percentageLabelText,
                                                suffix: const Text('%'),
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
                                  readOnly: true,
                                  value: ((_nicProfile?.nicBaseNicStr ?? 0.0) *
                                          100)
                                      .toStringAsFixed(0),
                                  contentType: ElTextFieldContentType.numeric,
                                  labelText: "Nic Str",
                                  labelPosition: ElTextFieldLabelPosition.left,
                                  suffix: const Text('%'),
                                ),
                                const Gap(8),
                                Row(
                                  spacing: 8.0,
                                  children: [
                                    Expanded(
                                      child: ElTextField(
                                        readOnly: true,
                                        value: (nicBases
                                                    .where((nicBase) =>
                                                        nicBase.isVG)
                                                    .fold(
                                                        0.0,
                                                        (sum, nicBase) =>
                                                            sum +
                                                            nicBase
                                                                .percentage) *
                                                100)
                                            .toStringAsFixed(0),
                                        contentType:
                                            ElTextFieldContentType.numeric,
                                        labelText: 'VG',
                                        labelPosition:
                                            ElTextFieldLabelPosition.left,
                                        suffix: const Text('%'),
                                      ),
                                    ),
                                    Expanded(
                                      child: ElTextField(
                                        readOnly: true,
                                        value: (nicBases
                                                    .where((nicBase) =>
                                                        !nicBase.isVG)
                                                    .fold(
                                                        0.0,
                                                        (sum, nicBase) =>
                                                            sum +
                                                            nicBase
                                                                .percentage) *
                                                100)
                                            .toStringAsFixed(0),
                                        contentType:
                                            ElTextFieldContentType.numeric,
                                        labelText: 'PG',
                                        labelPosition:
                                            ElTextFieldLabelPosition.left,
                                        suffix: const Text('%'),
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
                                                      readOnly: true,
                                                      value: nicBase.label,
                                                      contentType:
                                                          ElTextFieldContentType
                                                              .text,
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
                                                      readOnly: true,
                                                      value: (nicBase
                                                                  .percentage *
                                                              100)
                                                          .toStringAsFixed(0),
                                                      contentType:
                                                          ElTextFieldContentType
                                                              .numeric,
                                                      labelText: index == 0
                                                          ? 'Percentage'
                                                          : null,
                                                      suffix: const Text('%'),
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
                                  readOnly: true,
                                  value:
                                      ((_nicProfile?.targetNicStr ?? 0.0) * 100)
                                          .toStringAsFixed(2),
                                  contentType: ElTextFieldContentType.numeric,
                                  labelText: "Nic Str",
                                  labelPosition: ElTextFieldLabelPosition.left,
                                  suffix: const Text("%"),
                                ),
                                const Gap(8),
                                Row(
                                  spacing: 8.0,
                                  children: [
                                    Expanded(
                                      child: ElTextField(
                                        readOnly: true,
                                        value: ((_nicProfile?.targetVG ?? 0.0) *
                                                100)
                                            .toStringAsFixed(_getDecimalPlaces(
                                                            _nicProfile
                                                                    ?.targetVG ??
                                                                0.0) -
                                                        2 >
                                                    4
                                                ? _getDecimalPlaces(
                                                        _nicProfile?.targetVG ??
                                                            0.0) -
                                                    2
                                                : 4),
                                        contentType:
                                            ElTextFieldContentType.numeric,
                                        labelText: "VG",
                                        labelPosition:
                                            ElTextFieldLabelPosition.left,
                                        suffix: const Text("%"),
                                      ),
                                    ),
                                    Expanded(
                                      child: ElTextField(
                                        readOnly: true,
                                        value: ((_nicProfile?.targetPG ?? 0.0) *
                                                100)
                                            .toStringAsFixed(_getDecimalPlaces(
                                                            _nicProfile
                                                                    ?.targetPG ??
                                                                0.0) -
                                                        2 >
                                                    4
                                                ? _getDecimalPlaces(
                                                        _nicProfile?.targetPG ??
                                                            0.0) -
                                                    2
                                                : 4),
                                        contentType:
                                            ElTextFieldContentType.numeric,
                                        labelText: "PG",
                                        labelPosition:
                                            ElTextFieldLabelPosition.left,
                                        suffix: const Text("%"),
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
