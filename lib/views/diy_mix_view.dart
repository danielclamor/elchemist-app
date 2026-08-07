import 'package:collection/collection.dart';
import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/flavoring_entry_row.dart';
import 'package:elchemist_app/components/organisms/recipe_section.dart';
import 'package:elchemist_app/providers/mix_recipe_calculator.dart';
import 'package:elchemist_app/value_getters.dart';
import 'package:elchemist_app/models/ingredient.dart';
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

  void _addFlavoringEntry() {
    final flavor = 'Flavor ${_flavoringEntries.length + 1}';
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

  Widget _buildEntryRow(FlavoringEntry entry, bool withHeaders) {
    return FlavoringEntryRow(
      entry: entry,
      withHeaders: withHeaders,
      showDeleteIcon: true,
      onEntryDeleted: () => _removeFlavoringEntry(entry),
      onNameSubmitted: (value) => setState(() {}),
      onPercentSubmitted: (value) => setState(() {}),
      onIsVGChanged: (value) => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var wrapperWidth = screenSize.width < 1920 ? 800.0 : null;
    var sectionWidth = 500.0;
    var midSectionWidth = screenSize.width < 1920 ? sectionWidth : 400.0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    "DIY Mix",
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
                    Column(
                      spacing: 12.0,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: EdgeInsets.zero,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            constraints: const BoxConstraints(
                              maxWidth: 500,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "BATCH",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(16.0),
                                ElTextField(
                                  controller: _volumeController,
                                  contentType: ElTextFieldContentType.numeric,
                                  labelText: 'Volume',
                                  labelPosition: ElTextFieldLabelPosition.left,
                                  suffixText: 'mL',
                                  onSubmitted: (value) => setState(() {}),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: EdgeInsets.zero,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            constraints: const BoxConstraints(
                              maxWidth: 500,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      _flavoringEntries.length, (index) {
                                    final withHeaders =
                                        index == 0 ? true : false;

                                    return _buildEntryRow(
                                      _flavoringEntries[index],
                                      withHeaders,
                                    );
                                  }),
                                ),
                                Padding(
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
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: midSectionWidth,
                      ),
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
                                onSubmitted: (value) => setState(() {}),
                                suffixText: '%',
                              ),
                              const Gap(8),
                              Row(
                                spacing: 8.0,
                                children: [
                                  Expanded(
                                    child: ElTextField(
                                      controller: _nicBaseVGController,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      labelText: 'VG',
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      suffixText: '%',
                                      onSubmitted: (value) {
                                        setState(() {
                                          _nicBasePGController.text =
                                              (100 - (double.parse(value)))
                                                  .toString();
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ElTextField(
                                      controller: _nicBasePGController,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      labelText: 'PG',
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      suffixText: '%',
                                      onSubmitted: (value) {
                                        setState(() {
                                          _nicBaseVGController.text =
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
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: midSectionWidth,
                      ),
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
                                labelText: 'Nic Str',
                                labelPosition: ElTextFieldLabelPosition.left,
                                suffixText: '%',
                                onSubmitted: (value) => setState(() {}),
                              ),
                              const Gap(8.0),
                              Row(
                                spacing: 8.0,
                                children: [
                                  Expanded(
                                    child: ElTextField(
                                      controller: _targetVGController,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      labelText: 'VG',
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      suffixText: '%',
                                      onSubmitted: (value) {
                                        setState(() {
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
                                      labelText: 'PG',
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      suffixText: '%',
                                      onSubmitted: (value) {
                                        setState(() {
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
                        targetVG: double.parse(_targetVGController.text) / 100,
                        targetPG: double.parse(_targetPGController.text) / 100,
                        flavorings: _flavoringEntries,
                      ).ingredients,
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
