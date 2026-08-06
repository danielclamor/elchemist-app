import 'package:collection/collection.dart';
import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/flavoring_entry_row.dart';
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
  List<Ingredient> _ingredients = [];

  final List<FlavorEntry> _flavorEntries = [];

  late String _volume;
  late String _targetNicStr;
  late String _targetVG;
  late String _targetPG;
  late String _nicBaseNicStr;
  late String _nicBaseVG;
  late String _nicBasePG;

  @override
  void initState() {
    _volume = "30";
    _targetNicStr = "2";
    _targetVG = "40";
    _targetPG = "60";
    _nicBaseNicStr = "10";
    _nicBaseVG = "0";
    _nicBasePG = "100";

    _ingredients = <Ingredient>[
      Ingredient(
        name: "Nicotine Base",
        ratio: _getNicBaseValues().$1,
        volume: _getNicBaseValues().$2,
        weight: _getNicBaseValues().$3,
        type: IngredientType.nicotine,
      ),
      Ingredient(
        name: "VG",
        ratio: _getVGValues().$1,
        volume: _getVGValues().$2,
        weight: _getVGValues().$3,
        type: IngredientType.vg,
      ),
      Ingredient(
        name: "PG",
        ratio: _getPGValues().$1,
        volume: _getPGValues().$2,
        weight: _getPGValues().$3,
        type: IngredientType.pg,
      ),
    ];

    super.initState();
  }

  int _getDecimalPlaces(String value) {
    double doubleValue = double.parse(value);

    if (doubleValue == doubleValue.toInt()) return 0;

    List<String> parts = value.split('.');

    return parts.length > 1 ? parts[1].length : 0;
  }

  (double, double, double) _getNicBaseValues() {
    final double volume = _volume == "" ? 0.0 : double.parse(_volume);

    final double targetNicStr = double.parse(_targetNicStr) / 100;
    final double nicBaseNicStr = double.parse(_nicBaseNicStr) / 100;

    double nicBaseVGVol = nicBaseCompVol(
      volume,
      targetNicStr,
      nicBaseNicStr,
      double.parse(_nicBaseVG) / 100,
    );

    double nicBasePGVol = nicBaseCompVol(
      volume,
      targetNicStr,
      nicBaseNicStr,
      double.parse(_nicBasePG) / 100,
    );

    double nicotineVol = nicVol(
      volume,
      targetNicStr,
    );

    final nicBaseMixPerc = targetNicStr / nicBaseNicStr;

    return (
      nicBaseMixPerc,
      nicBaseMixPerc * volume,
      nicGrams(nicotineVol) + vgGrams(nicBaseVGVol) + pgGrams(nicBasePGVol),
    );
  }

  (double, double, double) _getFlavorValues(bool isVG, double percentage) {
    final double volume = _volume == "" ? 0.0 : double.parse(_volume);

    var flavoringVol = flavVol(
      volume,
      percentage,
    );

    return (
      percentage,
      flavVol(volume, percentage),
      isVG ? vgFlavGrams(flavoringVol) : pgFlavGrams(flavoringVol),
    );
  }

  (double, double, double) _getVGValues() {
    final double volume = _volume == "" ? 0.0 : double.parse(_volume);

    final double targetNicStr = double.parse(_targetNicStr) / 100;
    final double nicBaseNicStr = double.parse(_nicBaseNicStr) / 100;

    final vgFlavors = _ingredients
        .where((ingredient) => ingredient.type == IngredientType.vgFlavor);

    double totalFlavVGPerc = vgFlavors.isNotEmpty
        ? vgFlavors.fold(0.0, (sum, flavor) => sum + flavor.ratio)
        : 0.0;

    double nicBaseVGPerc =
        _nicBaseVG != "" ? double.parse(_nicBaseVG) / 100 : 0.0;

    double targetVG = _targetVG != "" ? double.parse(_targetVG) / 100 : 0.0;

    double vgMixPerc = targetVG -
        totalFlavVGPerc +
        (targetNicStr *
            (nicBaseVGPerc - targetVG - (nicBaseVGPerc / nicBaseNicStr)));

    double ingredientVGVol = volume * vgMixPerc;

    return (vgMixPerc, ingredientVGVol, vgGrams(ingredientVGVol));
  }

  (double, double, double) _getPGValues() {
    final double volume = _volume == "" ? 0.0 : double.parse(_volume);

    final double targetNicStr = double.parse(_targetNicStr) / 100;
    final double nicBaseNicStr = double.parse(_nicBaseNicStr) / 100;

    final pgFlavors = _ingredients
        .where((ingredient) => ingredient.type == IngredientType.pgFlavor);

    double totalFlavPGPerc = pgFlavors.isNotEmpty
        ? pgFlavors.fold(0.0, (sum, flavor) => sum + flavor.ratio)
        : 0.0;

    double nicBasePGPerc =
        _nicBasePG != "" ? double.parse(_nicBasePG) / 100 : 0.0;

    double targetPG = _targetPG != "" ? double.parse(_targetPG) / 100 : 0.0;

    double pgMixPerc = targetPG -
        totalFlavPGPerc +
        (targetNicStr *
            (nicBasePGPerc - targetPG - (nicBasePGPerc / nicBaseNicStr)));

    double ingredientPGVol = volume * pgMixPerc;

    return (pgMixPerc, ingredientPGVol, pgGrams(ingredientPGVol));
  }

  void _updateValues() {
    for (Ingredient ingredient in _ingredients) {
      var (percentage, volume, weight) = (0.0, 0.0, 0.0);
      switch (ingredient.type) {
        case IngredientType.nicotine:
          (percentage, volume, weight) = _getNicBaseValues();
        case IngredientType.vg:
          (percentage, volume, weight) = _getVGValues();
        case IngredientType.pg:
          (percentage, volume, weight) = _getPGValues();
        case IngredientType.vgFlavor:
          (percentage, volume, weight) = _getFlavorValues(
            true,
            ingredient.ratio,
          );
        case IngredientType.pgFlavor:
          (percentage, volume, weight) = _getFlavorValues(
            false,
            ingredient.ratio,
          );
      }

      setState(() {
        ingredient.ratio = percentage;
        ingredient.volume = volume;
        ingredient.weight = weight;
      });
    }
  }

  void _addEntry() {
    final flavor = 'Flavor ${_flavorEntries.length + 1}';
    const ratio = 0.0;

    final entry = FlavorEntry(
      name: flavor,
      ratio: ratio,
    );
    setState(() {
      _flavorEntries.add(entry);
      _ingredients.insert(
        _ingredients.length - 2,
        Ingredient(
          name: flavor,
          ratio: ratio,
          volume: 0.0,
          weight: 0.0,
          type: IngredientType.pgFlavor,
          id: entry.id,
        ),
      );
    });
    _updateValues();
  }

  void _removeEntry(FlavorEntry entry) {
    setState(() {
      entry.dispose();
      _flavorEntries.remove(entry);
      _ingredients.remove(
        _ingredients
            .firstWhereOrNull((ingredient) => ingredient.id == entry.id),
      );
    });
    _updateValues();
  }

  Widget _buildEntryRow(FlavorEntry entry, bool withHeaders) {
    return FlavoringEntryRow(
      entry: entry,
      withHeaders: withHeaders,
      showDeleteIcon: true,
      onEntryDeleted: () => _removeEntry(entry),
      onNameSubmitted: (value) {
        setState(() {
          entry.nameController.text = value;
        });
        final flavor = _ingredients.firstWhereOrNull(
          (ingredient) => ingredient.id == entry.id,
        );
        if (flavor != null) {
          setState(() {
            flavor.name = value;
          });
        }
      },
      onPercentSubmitted: (value) {
        setState(() {
          entry.percentageController.text = value;
        });
        final flavor = _ingredients.firstWhereOrNull(
          (ingredient) => ingredient.id == entry.id,
        );
        if (flavor != null) {
          setState(() {
            final (percentage, volume, weight) = _getFlavorValues(
              entry.isVG,
              entry.ratio,
            );
            flavor.ratio = percentage;
            flavor.volume = volume;
            flavor.weight = weight;
          });
          _updateValues();
        }
      },
      onIsVGChanged: (value) {
        setState(() {
          entry.isVG = value ?? false;
        });
        final flavor = _ingredients.firstWhereOrNull(
          (ingredient) => ingredient.id == entry.id,
        );
        if (flavor != null) {
          setState(() {
            flavor.type = value == true
                ? IngredientType.vgFlavor
                : IngredientType.pgFlavor;
          });
          _updateValues();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var wrapperWidth = screenSize.width < 1920 ? 500.0 : null;
    var section2Width = screenSize.width < 1920 ? 500.0 : 400.0;

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
                                  controller: TextEditingController(
                                    text: _volume,
                                  ),
                                  contentType: ElTextFieldContentType.numeric,
                                  labelText: 'Volume',
                                  labelPosition: ElTextFieldLabelPosition.left,
                                  suffixText: 'mL',
                                  onSubmitted: (value) {
                                    setState(() {
                                      _volume = value;
                                    });
                                    _updateValues();
                                  },
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
                                  children: List.generate(_flavorEntries.length,
                                      (index) {
                                    final withHeaders =
                                        index == 0 ? true : false;

                                    return _buildEntryRow(
                                      _flavorEntries[index],
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
                                        onPressed: () => _addEntry(),
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
                        maxWidth: section2Width,
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
                                controller: TextEditingController(
                                  text: _nicBaseNicStr,
                                ),
                                contentType: ElTextFieldContentType.numeric,
                                labelText: 'Nic Str',
                                labelPosition: ElTextFieldLabelPosition.left,
                                onSubmitted: (value) {
                                  setState(() {
                                    _nicBaseNicStr = value;
                                  });
                                  _updateValues();
                                },
                                suffixText: '%',
                              ),
                              const Gap(8),
                              Row(
                                spacing: 8.0,
                                children: [
                                  Expanded(
                                    child: ElTextField(
                                      controller: TextEditingController(
                                        text: _nicBaseVG,
                                      ),
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      labelText: 'VG',
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      suffixText: '%',
                                      onSubmitted: (value) {
                                        setState(() {
                                          _nicBaseVG = value;
                                          _nicBasePG =
                                              (100 - (double.parse(value)))
                                                  .toStringAsFixed(
                                            _getDecimalPlaces(
                                              value,
                                            ),
                                          );
                                        });
                                        _updateValues();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ElTextField(
                                      controller: TextEditingController(
                                        text: _nicBasePG,
                                      ),
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      labelText: 'PG',
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      suffixText: '%',
                                      onSubmitted: (value) {
                                        setState(() {
                                          _nicBasePG = value;
                                          _nicBaseVG =
                                              (100 - (double.parse(value)))
                                                  .toStringAsFixed(
                                            _getDecimalPlaces(
                                              value,
                                            ),
                                          );
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
                      constraints: BoxConstraints(
                        maxWidth: section2Width,
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
                                controller: TextEditingController(
                                  text: _targetNicStr,
                                ),
                                contentType: ElTextFieldContentType.numeric,
                                labelText: 'Nic Str',
                                labelPosition: ElTextFieldLabelPosition.left,
                                suffixText: '%',
                                onSubmitted: (value) {
                                  final percentage = double.parse(value);

                                  if (percentage == 0.0) {
                                    _ingredients.removeAt(0);
                                  } else {
                                    if (!_ingredients
                                        .map((ingredient) => ingredient.name)
                                        .contains("Nicotine Base")) {
                                      setState(() {});
                                      final (percentage, volume, weight) =
                                          _getNicBaseValues();
                                      _ingredients.insert(
                                        0,
                                        Ingredient(
                                          name: "Nicotine Base",
                                          ratio: percentage,
                                          volume: volume,
                                          weight: weight,
                                          type: IngredientType.nicotine,
                                        ),
                                      );
                                    }
                                  }

                                  setState(() {
                                    _targetNicStr = value;
                                  });

                                  _updateValues();
                                },
                              ),
                              const Gap(8.0),
                              Row(
                                spacing: 8.0,
                                children: [
                                  Expanded(
                                    child: ElTextField(
                                      controller: TextEditingController(
                                        text: _targetVG,
                                      ),
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      labelText: 'VG',
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      suffixText: '%',
                                      onSubmitted: (value) {
                                        setState(() {
                                          _targetVG = value;
                                          _targetPG =
                                              (100 - (double.parse(value)))
                                                  .toStringAsFixed(
                                            _getDecimalPlaces(
                                              value,
                                            ),
                                          );
                                        });
                                        _updateValues();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ElTextField(
                                      controller: TextEditingController(
                                        text: _targetPG,
                                      ),
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      labelText: 'PG',
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      suffixText: '%',
                                      onSubmitted: (value) {
                                        setState(() {
                                          _targetPG = value;
                                          _targetVG =
                                              (100 - (double.parse(value)))
                                                  .toStringAsFixed(
                                            _getDecimalPlaces(
                                              value,
                                            ),
                                          );
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
                      constraints: const BoxConstraints(
                        maxWidth: 500,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "RECIPE",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(24),
                              DataTable(
                                horizontalMargin: 0.0,
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      "Ingredient",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "mL",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "g",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    numeric: true,
                                  ),
                                ],
                                rows: [
                                  ..._ingredients.map(
                                    (ingredient) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            ingredient.name,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            '${ingredient.volume.toStringAsFixed(2)} mL',
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            '${ingredient.weight.toStringAsFixed(2)} g',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataRow(
                                    cells: [
                                      const DataCell(
                                        Text(
                                          "Sum",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${_ingredients.fold(0.0, (sum, ingredient) => sum + ingredient.volume).toStringAsFixed(2)} mL',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${_ingredients.fold(0.0, (sum, ingredient) => sum + ingredient.weight).toStringAsFixed(2)} g',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
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
