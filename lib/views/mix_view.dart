import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/components/atoms/el_dropdown_menu.dart';
import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/mix_recipe_table.dart';
import 'package:elchemist_app/constants.dart';
import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/ingredient.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/models/formula.dart';
import 'package:elchemist_app/models/nic_profile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
  final NicProfile? initialNicProfile;
  final bool isFinal;

  const MixView({
    super.key,
    required this.formula,
    this.initialNicProfile,
    this.isFinal = false,
  });

  @override
  State<MixView> createState() => _MixViewState();
}

class _MixViewState extends State<MixView> {
  final List<NicBaseOption> _nicBaseOptions = nicBaseOptionsData
      .map((option) => NicBaseOption.fromMap(option))
      .toList();

  final List<NicBaseEntry> _nicBaseEntries = [];

  NicProfile? _nicProfile;
  bool _isCustom = false;

  late TextEditingController _nicLevelController;
  late TextEditingController _volumeController;
  late TextEditingController _nicBaseNicStrController;
  late TextEditingController _nicBaseVGController;
  late TextEditingController _nicBasePGController;
  late TextEditingController _targetNicStrController;
  late TextEditingController _targetVGController;
  late TextEditingController _targetPGController;

  List<TextEditingController> get _allControllers => [
        _nicLevelController,
        _volumeController,
        _nicBaseNicStrController,
        _nicBaseVGController,
        _nicBasePGController,
        _targetNicStrController,
        _targetVGController,
        _targetPGController,
      ];

  final Ingredient _recipeVG = Ingredient(
    name: 'VG',
    percentage: 0.0,
    volume: 0.0,
    weight: 0.0,
    type: IngredientType.vg,
  );

  final Ingredient _recipePG = Ingredient(
    name: 'PG',
    percentage: 0.0,
    volume: 0.0,
    weight: 0.0,
    type: IngredientType.pg,
  );

  @override
  void initState() {
    super.initState();
    _nicProfile = widget.initialNicProfile;

    _nicLevelController = TextEditingController(
      text: (_nicProfile == null
              ? 0.0
              : (_nicProfile!.isNewMix
                  ? _nicProfile!.targetNicStr * 10
                  : _nicProfile!.targetNicStr * 2.5))
          .toString(),
    );
    _volumeController = TextEditingController(text: "0");
    _nicBaseNicStrController = TextEditingController(
      text: (_nicProfile == null ? 0.0 : _nicProfile!.nicBaseNicStr * 100)
          .toString(),
    );
    _nicBaseVGController = TextEditingController(text: "0");
    _nicBasePGController = TextEditingController(text: "0");
    _targetNicStrController = TextEditingController(
      text: (_nicProfile == null ? 0.0 : _nicProfile!.targetNicStr * 100)
          .toString(),
    );
    _targetVGController = TextEditingController(
      text:
          (_nicProfile == null ? 0.0 : _nicProfile!.targetVG * 100).toString(),
    );
    _targetPGController = TextEditingController(
      text:
          (_nicProfile == null ? 0.0 : _nicProfile!.targetPG * 100).toString(),
    );

    _calculateTotalNicBaseRatio();
  }

  void _calculateTotalNicBaseRatio() {
    if (_nicProfile != null) {
      _nicBaseVGController.text = (_nicProfile!.nicBases
                  .where((nicBase) => nicBase.isVG)
                  .fold(0.0, (sum, nicbase) => sum + nicbase.percentage) *
              100)
          .toString();

      _nicBasePGController.text = (_nicProfile!.nicBases
                  .where((nicBase) => !nicBase.isVG)
                  .fold(0.0, (sum, nicbase) => sum + nicbase.percentage) *
              100)
          .toString();
    }
  }

  void _updateValues() {
    // TODO add functionality
  }

  void _removeEntry(NicBaseEntry entry) {
    setState(() {
      entry.dispose();
      _nicBaseEntries.remove(entry);
    });
    _updateValues();
  }

  Widget _buildEntryRow(NicBaseEntry entry, bool withHeaders) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _isCustom && _nicBaseEntries.length > 1
            ? Padding(
                padding: EdgeInsets.only(top: withHeaders ? 28.0 : 4.0),
                child: IconButton(
                  onPressed: () => _removeEntry(entry),
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => ElDropdownMenu<NicBaseOption>(
              width: constraints.maxWidth,
              ignoring: !_isCustom,
              initialSelection: _nicBaseOptions.firstWhereOrNull(
                (option) => option == entry.nicBase?.nicBase,
              ),
              labelText: withHeaders ? 'Name' : null,
              dropdownMenuEntries:
                  UnmodifiableListView<DropdownMenuEntry<NicBaseOption>>(
                _nicBaseOptions.map<DropdownMenuEntry<NicBaseOption>>(
                  (option) => DropdownMenuEntry<NicBaseOption>(
                    value: option,
                    label: option.label,
                  ),
                ),
              ),
              onSelected: (value) {
                final nicBaseOption = value;
                setState(() {
                  entry.isVG = nicBaseOption?.isVG ?? false;
                  // _ingredients[0] = _nicBaseIngredient;
                  _calculateTotalNicBaseRatio();
                });
                _updateValues();
              },
            ),
          ),
        ),
        const Gap(8),
        Container(
          constraints: const BoxConstraints(maxWidth: 120),
          child: ElTextField(
            labelText: withHeaders ? 'Percentage' : null,
            readOnly: !_isCustom,
            value: ((entry.nicBase?.percentage ?? 0.0) * 100).toString(),
            contentType: ElTextFieldContentType.numeric,
            suffix: const Text("%"),
            onSubmitted: (value) {
              setState(() {
                _nicBaseVGController.text = (_nicBaseEntries
                            .where((nicBaseEntry) => nicBaseEntry.isVG)
                            .fold(
                              0.0,
                              (sum, nicBaseEntry) =>
                                  sum +
                                  (double.parse(nicBaseEntry
                                          .percentageController.text) /
                                      100),
                            ) *
                        100)
                    .toStringAsFixed(0);

                _nicBasePGController.text = (_nicBaseEntries
                            .where((nicBaseEntry) => !nicBaseEntry.isVG)
                            .fold(
                              0.0,
                              (sum, nicBaseEntry) =>
                                  sum +
                                  (double.parse(nicBaseEntry
                                          .percentageController.text) /
                                      100),
                            ) *
                        100)
                    .toStringAsFixed(0);
              });
              _updateValues();
            },
          ),
        ),
        const Gap(12.0),
        ElCheckbox(
          labelText: withHeaders ? 'VG' : null,
          value: entry.isVG,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var wrapperWidth = screenSize.width < 1920 ? 500.0 : null;
    var sectionWidth = 500.0;
    var midSectionWidth = screenSize.width < 1920 ? sectionWidth : 400.0;

    final Formula formula = widget.formula;
    final bool isFinal = widget.isFinal;

    List<Flavoring> flavorings = [];

    if (_nicProfile != null) {
      flavorings = _nicProfile!.flavorings;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    "Search and Mix",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const Gap(24),
              Container(
                constraints: BoxConstraints(
                  maxWidth: wrapperWidth ?? double.infinity,
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20.0,
                  runSpacing: 8.0,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: sectionWidth,
                      ),
                      child: Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            formula.brand.toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            formula.name,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${formula.nicType.toString()} — ${formula.chilltype.toString()}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Gap(20),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ElDropdownMenu<NicProfile>(
                                          width: 360,
                                          labelText: 'Profile',
                                          initialSelection: _nicProfile,
                                          dropdownMenuEntries:
                                              UnmodifiableListView<
                                                  DropdownMenuEntry<
                                                      NicProfile>>(
                                            formula.nicProfiles.map<
                                                DropdownMenuEntry<NicProfile>>(
                                              (nicProfile) =>
                                                  DropdownMenuEntry<NicProfile>(
                                                value: nicProfile,
                                                label: nicProfile.label,
                                              ),
                                            ),
                                          ),
                                          ignoring: isFinal,
                                          onSelected: isFinal
                                              ? null
                                              : (NicProfile? value) {
                                                  setState(() {
                                                    _nicProfile = value;
                                                  });

                                                  // TODO add functionality on nicprofile select
                                                },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 140,
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsGeometry.only(
                                            left: 8.0,
                                            right: 12.0,
                                          ),
                                          child: ElTextField(
                                            value: _nicLevelController.text,
                                            contentType:
                                                ElTextFieldContentType.numeric,
                                            readOnly: _nicProfile == null &&
                                                !_isCustom,
                                            labelText: 'Nic Level',
                                            suffix: const Text('mg'),
                                            onSubmitted: _nicProfile == null
                                                ? null
                                                : (value) {
                                                    // TODO add funtionality
                                                  },
                                          ),
                                        ),
                                      ),
                                      ElCheckbox(
                                        width: 50,
                                        value: _isCustom,
                                        labelText: 'Custom',
                                        onChanged: _nicProfile == null
                                            ? null
                                            : (bool? value) {
                                                setState(() {
                                                  _isCustom = value ?? false;
                                                });

                                                if (value == false) {
                                                  // TODO reset nicprofile
                                                }
                                              },
                                      ),
                                    ],
                                  ),
                                  _nicProfile == null
                                      ? const SizedBox.shrink()
                                      : Column(
                                          children: [
                                            const Gap(8.0),
                                            ElTextField(
                                              value: _volumeController.text,
                                              contentType:
                                                  ElTextFieldContentType
                                                      .numeric,
                                              labelText: 'Volume',
                                              labelPosition:
                                                  ElTextFieldLabelPosition.left,
                                              suffix: const Text('mL'),
                                              onSubmitted: (value) {
                                                setState(() {
                                                  // _volumeController.text =
                                                  //     value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ),
                          const Gap(8.0),
                          _nicProfile == null
                              ? const SizedBox.shrink()
                              : Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "FLAVOURING",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Gap(20),
                                        Column(
                                          spacing: 8.0,
                                          children: List.generate(
                                            flavorings.length,
                                            (index) {
                                              final flavoring =
                                                  flavorings[index];
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: ElTextField(
                                                      readOnly: true,
                                                      labelText: index == 0
                                                          ? 'Name'
                                                          : null,
                                                      value: flavoring.name,
                                                      contentType:
                                                          ElTextFieldContentType
                                                              .text,
                                                    ),
                                                  ),
                                                  const Gap(8.0),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: 140,
                                                        child: ElTextField(
                                                          labelText: index == 0
                                                              ? 'Percentage'
                                                              : null,
                                                          readOnly: !_isCustom,
                                                          value: (flavoring
                                                                      .percentage *
                                                                  100)
                                                              .toStringAsFixed(
                                                                  4),
                                                          contentType:
                                                              ElTextFieldContentType
                                                                  .numeric,
                                                          suffix:
                                                              const Text("%"),
                                                        ),
                                                      ),
                                                      const Gap(12.0),
                                                      ElCheckbox(
                                                        labelText: index == 0
                                                            ? 'VG'
                                                            : null,
                                                        value: flavoring.isVG,
                                                        onChanged: null,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: midSectionWidth,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "NIC BASE",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(20),
                              ElTextField(
                                value: _nicBaseNicStrController.text,
                                contentType: ElTextFieldContentType.numeric,
                                labelText: 'Nic Str',
                                labelPosition: ElTextFieldLabelPosition.left,
                                readOnly: true,
                                suffix: const Text('%'),
                              ),
                              const Gap(8.0),
                              Row(
                                spacing: 8.0,
                                children: [
                                  Expanded(
                                    child: ElTextField(
                                      labelText: "VG",
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      value: _nicBaseVGController.text,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      readOnly: true,
                                      suffix: const Text('%'),
                                    ),
                                  ),
                                  Expanded(
                                    child: ElTextField(
                                      labelText: "PG",
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      value: _nicBasePGController.text,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      readOnly: true,
                                      suffix: const Text('%'),
                                    ),
                                  ),
                                ],
                              ),
                              _nicBaseEntries.isEmpty
                                  ? const SizedBox.shrink()
                                  : Column(
                                      children: [
                                        const Gap(16.0),
                                        Divider(
                                          thickness: 1,
                                          color: Theme.of(context).focusColor,
                                        ),
                                        const Gap(16.0),
                                        Column(
                                          children: List.generate(
                                              _nicBaseEntries.length, (index) {
                                            return _buildEntryRow(
                                                _nicBaseEntries[index],
                                                index == 0);
                                          }),
                                        )
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: midSectionWidth,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "TARGET",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(20),
                              ElTextField(
                                labelText: "Nic Str",
                                labelPosition: ElTextFieldLabelPosition.left,
                                value: _targetNicStrController.text,
                                readOnly: true,
                                contentType: ElTextFieldContentType.numeric,
                                suffix: const Text('%'),
                                onSubmitted: (value) => _updateValues(),
                              ),
                              const Gap(8),
                              Row(
                                spacing: 8.0,
                                children: [
                                  Expanded(
                                    child: ElTextField(
                                      labelText: "VG",
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      value: _targetVGController.text,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      readOnly: !_isCustom,
                                      suffix: const Text('%'),
                                      onSubmitted: (value) {
                                        setState(() {
                                          _targetVGController.text = value;
                                          _targetPGController.text =
                                              (100 - (double.parse(value)))
                                                  .toString();
                                        });
                                        _updateValues();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ElTextField(
                                      labelText: "PG",
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      value: _targetPGController.text,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      readOnly: !_isCustom,
                                      suffix: const Text('%'),
                                      onSubmitted: (value) {
                                        setState(() {
                                          _targetPGController.text = value;
                                          _targetVGController.text =
                                              (100 - (double.parse(value)))
                                                  .toString();
                                        });
                                        _updateValues();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: sectionWidth,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            4.0,
                          ),
                        ),
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "RECIPE",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(24),
                              MixRecipeTable(
                                nicBases: _nicBaseEntries.map((entry) {
                                  final percentage = (double.parse(
                                              _targetNicStrController.text) *
                                          double.parse(
                                              _nicBaseNicStrController.text)) *
                                      double.parse(
                                          entry.percentageController.text);

                                  final volume = _volumeController.text == ""
                                      ? 0.0
                                      : percentage *
                                          double.parse(_volumeController.text);

                                  final nicBase = entry.nicBase;
                                  final weight = nicBase == null
                                      ? 0.0
                                      : volume *
                                          (nicBase.isVG
                                              ? vgDensity
                                              : pgDensity);

                                  return Ingredient(
                                    name: entry.nicBase?.label ?? '',
                                    percentage: percentage,
                                    volume: volume,
                                    weight: weight,
                                    type: IngredientType.nicotine,
                                  );
                                }).toList(),
                                flavorings: flavorings.map(
                                  (flavor) {
                                    final volume = _volumeController.text == ""
                                        ? 0.0
                                        : flavor.percentage *
                                            double.parse(
                                              _volumeController.text,
                                            );

                                    final weight = volume *
                                        (flavor.isVG ? vgDensity : pgDensity);

                                    return Ingredient(
                                      name: flavor.name,
                                      percentage: flavor.percentage,
                                      volume: volume,
                                      weight: weight,
                                      type: flavor.isVG
                                          ? IngredientType.vgFlavor
                                          : IngredientType.pgFlavor,
                                    );
                                  },
                                ).toList(),
                                vg: _recipeVG,
                                pg: _recipePG,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
