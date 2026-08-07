import 'package:elchemist_app/components/molecules/flavoring_entry_row.dart';
import 'package:elchemist_app/components/organisms/batch_section.dart';
import 'package:elchemist_app/components/organisms/flavoring_section.dart';
import 'package:elchemist_app/components/organisms/nic_base_section.dart';
import 'package:elchemist_app/components/organisms/recipe_section.dart';
import 'package:elchemist_app/components/organisms/target_section.dart';
import 'package:elchemist_app/providers/mix_recipe_calculator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DiyMixView extends StatefulWidget {
  const DiyMixView({super.key});

  @override
  State<DiyMixView> createState() => _DiyMixViewState();
}

class _DiyMixViewState extends State<DiyMixView> {
  final List<FlavoringEntry> _flavoringEntries = [];

  late TextEditingController _volumeController;
  late TextEditingController _nicBaseNicStrController;
  late TextEditingController _nicBaseVGController;
  late TextEditingController _nicBasePGController;
  late TextEditingController _targetNicStrController;
  late TextEditingController _targetVGController;
  late TextEditingController _targetPGController;

  List<TextEditingController> get _allControllers => [
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
    _volumeController = TextEditingController(text: "30");
    _targetNicStrController = TextEditingController(text: "2");
    _targetVGController = TextEditingController(text: "40");
    _targetPGController = TextEditingController(text: "60");
    _nicBaseNicStrController = TextEditingController(text: "10");
    _nicBaseVGController = TextEditingController(text: "0");
    _nicBasePGController = TextEditingController(text: "100");

    super.initState();
  }

  @override
  void dispose() {
    for (final c in _allControllers) {
      c.dispose();
    }

    super.dispose();
  }

  void _addFlavoringEntry() {
    final flavor = 'Flavour ${_flavoringEntries.length + 1}';
    const ratio = 0.0;

    final entry = FlavoringEntry(
      name: flavor,
      ratio: ratio,
    );
    setState(() {
      _flavoringEntries.add(entry);
    });
  }

  void _removeFlavoringEntry(FlavoringEntry entry) {
    setState(() {
      entry.dispose();
      _flavoringEntries.remove(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var wrapperWidth = screenSize.width < 1920 ? 800.0 : null;
    var sectionWidth = 500.0;
    var midSectionWidth = screenSize.width < 1920 ? sectionWidth : 400.0;

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
                  "DIY Mix",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
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
                      Column(
                        spacing: 12.0,
                        children: [
                          BatchSection(
                            width: sectionWidth,
                            volumeController: _volumeController,
                            onVolumeSubmitted: (value) => setState(() {}),
                          ),
                          FlavoringSection(
                            width: sectionWidth,
                            flavoringEntries: List.generate(
                              _flavoringEntries.length,
                              (index) {
                                final entry = _flavoringEntries[index];
                                final withHeaders = index == 0 ? true : false;

                                return FlavoringEntryRow(
                                  entry: entry,
                                  withHeaders: withHeaders,
                                  showDeleteIcon: true,
                                  onEntryDeleted: () =>
                                      _removeFlavoringEntry(entry),
                                  onNameSubmitted: (value) => setState(() {}),
                                  onPercentSubmitted: (value) =>
                                      setState(() {}),
                                  onIsVGChanged: (value) => setState(() {}),
                                );
                              },
                            ),
                            addEntryButton: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => _addFlavoringEntry(),
                                    child: const Text("+ Add"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      NicBaseSection(
                        width: midSectionWidth,
                        nicStrController: _nicBaseNicStrController,
                        onNicStrSubmitted: (value) => setState(() {}),
                        vgController: _nicBaseVGController,
                        onVGSubmitted: (value) {
                          setState(() {
                            _nicBasePGController.text =
                                (100 - (double.parse(value))).toString();
                          });
                        },
                        pgController: _nicBasePGController,
                        onPGSubmitted: (value) {
                          setState(() {
                            _nicBaseVGController.text =
                                (100 - (double.parse(value))).toString();
                          });
                        },
                      ),
                      TargetSection(
                        width: midSectionWidth,
                        nicStrController: _targetNicStrController,
                        onNicStrSubmitted: (value) => setState(() {}),
                        vgController: _targetVGController,
                        onVGSubmitted: (value) {
                          setState(() {
                            _targetPGController.text =
                                (100 - (double.parse(value))).toString();
                          });
                        },
                        pgController: _targetPGController,
                        onPGSubmitted: (value) {
                          setState(() {
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
                          nicBaseVG:
                              double.parse(_nicBaseVGController.text) / 100,
                          nicBasePG:
                              double.parse(_nicBasePGController.text) / 100,
                          targetNicStr:
                              double.parse(_targetNicStrController.text) / 100,
                          targetVG:
                              double.parse(_targetVGController.text) / 100,
                          targetPG:
                              double.parse(_targetPGController.text) / 100,
                          flavoringEntries: _flavoringEntries,
                        ).ingredients,
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
