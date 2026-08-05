import 'package:collection/collection.dart';
import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/components/atoms/el_dropdown_menu.dart';
import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/mix_recipe_table.dart';
import 'package:elchemist_app/constants.dart';
import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/models/formula.dart';
import 'package:elchemist_app/models/nic_profile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NicBaseEntry {
  NicBaseEntry({
    NicBase? nicBase,
  })  : id = UniqueKey(),
        nicBase = nicBase,
        percentageController = TextEditingController(
          text: ((nicBase?.percentage ?? 0.0) * 100).toStringAsFixed(0),
        );

  final Key id;
  NicBase? nicBase;
  final TextEditingController percentageController;

  void dispose() {
    percentageController.dispose();
  }

  bool get isVG => nicBase?.isVG ?? false;

  String get code => nicBase?.code ?? '';

  double get ratio => double.parse(percentageController.text) / 100;
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

  @override
  void initState() {
    _setNicProfile(widget.initialNicProfile);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (final c in _allControllers) {
      c.dispose();
    }
  }

  void _setNicProfile(NicProfile? nicProfile) {
    setState(() {
      if (_nicProfile != nicProfile) {
        _nicProfile = nicProfile;
      }

      if (_nicProfile == null) {
        _volumeController = TextEditingController(text: "0");
        _nicLevelController = TextEditingController(text: "0");

        _targetNicStrController = TextEditingController(text: "0");
        _targetVGController = TextEditingController(text: "0");
        _targetPGController = TextEditingController(text: "0");

        _nicBaseNicStrController = TextEditingController(text: "0");
        _nicBaseVGController = TextEditingController(text: "0");
        _nicBasePGController = TextEditingController(text: "0");
      } else {
        _nicLevelController.text =
            (_nicProfile!.targetNicStr * (_nicProfile!.isNewMix ? 1000.0 : 250))
                .toString();
        _nicBaseNicStrController.text =
            (_nicProfile!.nicBaseNicStr * 100.0).toString();
        _targetNicStrController.text =
            (_nicProfile!.targetNicStr * 100.0).toString();
        _targetVGController.text = (_nicProfile!.targetVG * 100.0).toString();
        _targetPGController.text = (_nicProfile!.targetPG * 100.0).toString();
      }

      if (_nicBaseEntries.isNotEmpty) {
        _nicBaseEntries.clear();
      }
    });

    _populateNicBase();
  }

  void _populateNicBase() {
    if (_nicProfile == null) return;

    for (NicBase nicBase in _nicProfile!.nicBases) {
      _addEntry(
        NicBaseEntry(
          nicBase: nicBase,
        ),
      );
    }

    _calculateTotalNicBaseRatio();
  }

  void _calculateTotalNicBaseRatio() {
    double totalNicBaseVGPerc = (_nicBaseEntries
            .where((entry) => entry.isVG)
            .fold(0.0, (sum, entry) => sum + entry.ratio)) *
        100;

    double totalNicBasePGPerc = (_nicBaseEntries
            .where((entry) => !entry.isVG)
            .fold(0.0, (sum, entry) => sum + entry.ratio)) *
        100;

    setState(() {
      _nicBaseVGController.text = totalNicBaseVGPerc.toString();
      _nicBasePGController.text = totalNicBasePGPerc.toString();
    });
  }

  void _addEntry(NicBaseEntry? entry) {
    setState(() {
      _nicBaseEntries.add(entry ?? NicBaseEntry());
    });
  }

  void _removeEntry(NicBaseEntry entry) {
    setState(() {
      entry.dispose();
      _nicBaseEntries.remove(entry);
    });
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
                if (nicBaseOption == null) return;

                setState(() {
                  entry.nicBase = NicBase(
                    nicBase: nicBaseOption,
                    percentage: entry.ratio,
                  );
                });
                _calculateTotalNicBaseRatio();
              },
            ),
          ),
        ),
        const Gap(8),
        Container(
          constraints: const BoxConstraints(maxWidth: 120),
          child: ElTextField(
            controller: entry.percentageController,
            contentType: ElTextFieldContentType.numeric,
            labelText: withHeaders ? 'Percentage' : null,
            readOnly: !_isCustom,
            suffix: const Text("%"),
            onSubmitted: (value) {
              _calculateTotalNicBaseRatio();
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
    var wrapperWidth = screenSize.width < 1920 ? 800.0 : null;
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
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            constraints: BoxConstraints(
              maxWidth: wrapperWidth ?? double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mix",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(24),
                Wrap(
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
                              padding: const EdgeInsets.all(16.0),
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
                                                  _setNicProfile(value);
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
                                            controller: _nicLevelController,
                                            contentType:
                                                ElTextFieldContentType.numeric,
                                            readOnly: _nicProfile == null ||
                                                !_isCustom,
                                            labelText: 'Nic Level',
                                            suffix: const Text('mg'),
                                            onSubmitted: _nicProfile == null &&
                                                    !_isCustom
                                                ? null
                                                : (value) {
                                                    if (_nicProfile != null) {
                                                      double targetNicStr =
                                                          double.parse(value) /
                                                              (_nicProfile!
                                                                      .isNewMix
                                                                  ? 10
                                                                  : 2.5);
                                                      setState(() {
                                                        _targetNicStrController
                                                                .text =
                                                            targetNicStr
                                                                .toString();
                                                      });
                                                    }
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
                                                  _setNicProfile(_nicProfile);
                                                }
                                              },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Gap(8.0),
                                      ElTextField(
                                        controller: _volumeController,
                                        contentType:
                                            ElTextFieldContentType.numeric,
                                        labelText: 'Volume',
                                        labelPosition:
                                            ElTextFieldLabelPosition.left,
                                        suffix: const Text('mL'),
                                        onSubmitted: (value) {
                                          setState(() {});
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
                                                      controller:
                                                          TextEditingController(
                                                        text: flavoring.name,
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
                                                  const Gap(8.0),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: 140,
                                                        child: ElTextField(
                                                          controller:
                                                              TextEditingController(
                                                            text: (flavoring
                                                                        .percentage *
                                                                    100)
                                                                .toStringAsFixed(
                                                                    4),
                                                          ),
                                                          contentType:
                                                              ElTextFieldContentType
                                                                  .numeric,
                                                          labelText: index == 0
                                                              ? 'Percentage'
                                                              : null,
                                                          readOnly: !_isCustom,
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
                                controller: _nicBaseNicStrController,
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
                                      controller: _nicBaseVGController,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      labelText: "VG",
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      readOnly: true,
                                      suffix: const Text('%'),
                                    ),
                                  ),
                                  Expanded(
                                    child: ElTextField(
                                      controller: _nicBasePGController,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      labelText: "PG",
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
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
                                          spacing: 8.0,
                                          children: List.generate(
                                              _nicBaseEntries.length, (index) {
                                            return _buildEntryRow(
                                              _nicBaseEntries[index],
                                              index == 0,
                                            );
                                          }),
                                        )
                                      ],
                                    ),
                              _isCustom &&
                                      double.parse(
                                              _targetNicStrController.text) >
                                          0.0
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () => _addEntry(null),
                                            child: const Text("+ Add"),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
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
                                controller: _targetNicStrController,
                                contentType: ElTextFieldContentType.numeric,
                                labelText: "Nic Str",
                                labelPosition: ElTextFieldLabelPosition.left,
                                readOnly: true,
                                suffix: const Text('%'),
                              ),
                              const Gap(8),
                              Row(
                                spacing: 8.0,
                                children: [
                                  Expanded(
                                    child: ElTextField(
                                      controller: _targetVGController,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      labelText: "VG",
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      readOnly: !_isCustom,
                                      suffix: const Text('%'),
                                      onSubmitted: (value) {
                                        setState(() {
                                          _targetVGController.text = value;
                                          _targetPGController.text =
                                              (100 - (double.parse(value)))
                                                  .toString();
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ElTextField(
                                      controller: _targetPGController,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      labelText: "PG",
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      readOnly: !_isCustom,
                                      suffix: const Text('%'),
                                      onSubmitted: (value) {
                                        setState(() {
                                          _targetPGController.text = value;
                                          _targetVGController.text =
                                              (100 - (double.parse(value)))
                                                  .toString();
                                        });
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
                    SizedBox(
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
                                batchVolume:
                                    double.parse(_volumeController.text),
                                nicBaseNicStr: double.parse(
                                        _nicBaseNicStrController.text) /
                                    100,
                                targetNicStr:
                                    double.parse(_targetNicStrController.text) /
                                        100,
                                targetVG:
                                    double.parse(_targetVGController.text) /
                                        100,
                                targetPG:
                                    double.parse(_targetPGController.text) /
                                        100,
                                nicBaseEntries: _nicBaseEntries,
                                flavorings: flavorings,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
