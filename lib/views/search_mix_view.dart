import 'package:elchemist_app/components/molecules/flavoring_entry_row.dart';
import 'package:elchemist_app/components/molecules/nic_base_entry_row.dart';
import 'package:elchemist_app/components/organisms/batch_section.dart';
import 'package:elchemist_app/components/organisms/flavoring_section.dart';
import 'package:elchemist_app/components/organisms/formula_section.dart';
import 'package:elchemist_app/components/organisms/nic_base_section.dart';
import 'package:elchemist_app/components/organisms/recipe_section.dart';
import 'package:elchemist_app/components/organisms/target_section.dart';
import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/models/nic_profile.dart';
import 'package:elchemist_app/models/formula.dart';
import 'package:elchemist_app/providers/mix_recipe_calculator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchMixView extends StatefulWidget {
  final List<Formula> formulas;

  const SearchMixView({
    super.key,
    required this.formulas,
  });

  @override
  State<SearchMixView> createState() => _SearchMixViewState();
}

class _SearchMixViewState extends State<SearchMixView> {
  final List<NicBaseEntry> _nicBaseEntries = [];

  final List<FlavoringEntry> _flavoringEntries = [];

  Formula? _formula;
  NicProfile? _nicProfile;
  bool _isCustom = false;

  late SearchController _searchController;
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
        _targetPGController
      ];

  @override
  void initState() {
    _searchController = SearchController();
    _setNicProfile(null);

    super.initState();
  }

  @override
  void dispose() {
    for (final c in _allControllers) {
      c.dispose();
    }

    super.dispose();
  }

  void _changeFormula() {
    _searchController.clear();
    setState(() {
      _formula = null;
      _setNicProfile(null);
    });
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
        _flavoringEntries.clear();
      }
    });

    _populateFlavoringEntries();
    _populateNicBaseEntries();
  }

  void _populateFlavoringEntries() {
    if (_nicProfile == null) return;

    for (Flavoring flavoring in _nicProfile!.flavorings) {
      _addFlavoringEntry(
        FlavoringEntry(
          name: flavoring.name,
          ratio: flavoring.ratio,
          isVG: flavoring.isVG,
        ),
      );
    }
  }

  void _addFlavoringEntry(FlavoringEntry? entry) {
    setState(() {
      _flavoringEntries.add(entry ?? FlavoringEntry());
    });
  }

  // void _removeFlavoringEntry(FlavoringEntry entry) {
  //   setState(() {
  //     entry.dispose();
  //     _flavoringEntries.remove(entry);
  //   });
  // }

  void _populateNicBaseEntries() {
    if (_nicProfile == null) return;

    for (NicBase nicBase in _nicProfile!.nicBases) {
      _addNicBaseEntry(
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

  void _addNicBaseEntry(NicBaseEntry? entry) {
    setState(() {
      _nicBaseEntries.add(entry ?? NicBaseEntry());
    });
  }

  void _removeNicBaseEntry(NicBaseEntry entry) {
    setState(() {
      entry.dispose();
      _nicBaseEntries.remove(entry);
    });
    _calculateTotalNicBaseRatio();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var wrapperWidth = screenSize.width < 1920 ? 800.0 : null;
    var sectionWidth = 500.0;
    var midSectionWidth = screenSize.width < 1920 ? sectionWidth : 400.0;

    final List<Formula> formulas = widget.formulas;

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
                  "Search and Mix",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20.0,
                  runSpacing: 20.0,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: sectionWidth,
                      ),
                      child: Column(
                        spacing: 20.0,
                        children: [
                          FormulaSection(
                            formula: _formula,
                            searchController: _searchController,
                            suggestionsBuilder: (context, controller) {
                              final String input =
                                  controller.value.text.toLowerCase();
                              final Iterable<Formula> filteredSuggestions =
                                  formulas.where((formulaItem) {
                                return formulaItem.name
                                    .toLowerCase()
                                    .contains(input);
                              });

                              return filteredSuggestions.map((suggestionItem) {
                                return ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        suggestionItem.brand.toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        suggestionItem.name,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${suggestionItem.nicType.toString()} — ${suggestionItem.chilltype.toString()}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _searchController.closeView(
                                        suggestionItem.name,
                                      );
                                      _formula = suggestionItem;
                                    });
                                  },
                                );
                              });
                            },
                            onChangeFormula: () => _changeFormula(),
                            nicProfile: _nicProfile,
                            onNicProfileSelected: (NicProfile? value) {
                              setState(() {
                                _nicProfile = value;
                              });
                              _setNicProfile(value);
                            },
                            nicLevelController: _nicLevelController,
                            onNicLevelSubmitted:
                                _nicProfile == null && !_isCustom
                                    ? null
                                    : (value) {
                                        if (_nicProfile != null) {
                                          double targetNicStr =
                                              double.parse(value) /
                                                  (_nicProfile!.isNewMix
                                                      ? 10
                                                      : 2.5);
                                          setState(() {
                                            _targetNicStrController.text =
                                                targetNicStr.toString();
                                          });
                                        }
                                      },
                            showCustomCheckBox: true,
                            isCustom: _isCustom,
                            onIsCustomChanged: _nicProfile == null
                                ? null
                                : (bool? value) {
                                    setState(() {
                                      _isCustom = value ?? false;
                                    });

                                    if (value == false) {
                                      _setNicProfile(
                                        _nicProfile,
                                      );
                                    }
                                  },
                          ),
                          _nicProfile == null
                              ? const SizedBox.shrink()
                              : BatchSection(
                                  volumeController: _volumeController,
                                ),
                          _nicProfile == null
                              ? const SizedBox.shrink()
                              : FlavoringSection(
                                  flavoringEntries: List.generate(
                                    _flavoringEntries.length,
                                    (index) {
                                      final entry = _flavoringEntries[index];
                                      return FlavoringEntryRow(
                                        entry: entry,
                                        withHeaders: index == 0,
                                        showDeleteIcon: false,
                                        onPercentSubmitted: _isCustom
                                            ? (value) => setState(() {})
                                            : null,
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                    NicBaseSection(
                      width: midSectionWidth,
                      nicStrController: _nicBaseNicStrController,
                      vgController: _nicBaseVGController,
                      pgController: _nicBasePGController,
                      nicBaseEntries: List.generate(
                        _nicBaseEntries.length,
                        (index) {
                          final entry = _nicBaseEntries[index];
                          return NicBaseEntryRow(
                            entry: entry,
                            isCustom: _isCustom,
                            withHeaders: index == 0,
                            showDeleteIcon:
                                _isCustom && _nicBaseEntries.length > 1,
                            onEntryDeleted: () => _removeNicBaseEntry(entry),
                            onOptionSelected: (value) {
                              final nicBaseOption = value;

                              if (nicBaseOption == null) {
                                return;
                              }

                              setState(() {
                                entry.nicBase = NicBase(
                                  nicBaseOption: nicBaseOption,
                                  ratio: entry.ratio,
                                );
                              });

                              _calculateTotalNicBaseRatio();
                            },
                            onPercentSubmitted: (value) =>
                                _calculateTotalNicBaseRatio(),
                          );
                        },
                      ),
                      addEntryButton: !_isCustom ||
                              double.parse(_targetNicStrController.text) <= 0.0
                          ? null
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => _addNicBaseEntry(null),
                                    child: const Text("+ Add"),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    TargetSection(
                      width: midSectionWidth,
                      nicStrController: _targetNicStrController,
                      vgController: _targetVGController,
                      onVGSubmitted: !_isCustom
                          ? null
                          : (value) {
                              setState(() {
                                _targetVGController.text = value;
                                _targetPGController.text =
                                    (100 - (double.parse(value))).toString();
                              });
                            },
                      pgController: _targetPGController,
                      onPGSubmitted: !_isCustom
                          ? null
                          : (value) {
                              setState(() {
                                _targetPGController.text = value;
                                _targetVGController.text =
                                    (100 - (double.parse(value))).toString();
                              });
                            },
                    ),
                    RecipeSection(
                      width: sectionWidth,
                      ingredients: MixRecipeCalculator(
                        batchVolume: double.parse(_volumeController.text),
                        nicBaseNicStr:
                            double.parse(_nicBaseNicStrController.text) / 100,
                        targetNicStr:
                            double.parse(_targetNicStrController.text) / 100,
                        targetVG: double.parse(_targetVGController.text) / 100,
                        targetPG: double.parse(_targetPGController.text) / 100,
                        nicBaseEntries: _nicBaseEntries,
                        flavoringEntries: _flavoringEntries,
                      ).ingredients,
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
