import 'package:collection/collection.dart';
import 'package:elchemist_app/formulas.dart';
import 'package:elchemist_app/models/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FlavorEntry {
  FlavorEntry({
    String? flavor,
    String? percentage,
  })  : id = UniqueKey(),
        flavorController = TextEditingController(text: flavor),
        percentageController = TextEditingController(text: percentage);

  final Key id;
  final TextEditingController flavorController;
  final TextEditingController percentageController;
  final FocusNode flavorFocusNode = FocusNode();
  final FocusNode percentageFocusNode = FocusNode();
  bool isVG = false;

  void dispose() {
    flavorController.dispose();
    percentageController.dispose();
    flavorFocusNode.dispose();
    percentageFocusNode.dispose();
  }
}

class DiyMixView extends StatefulWidget {
  const DiyMixView({super.key});

  @override
  State<DiyMixView> createState() => _DiyMixViewState();
}

class _DiyMixViewState extends State<DiyMixView> {
  List<Ingredient> ingredients = [];

  final List<FlavorEntry> _flavorEntries = [];

  late TextEditingController _volumeController;

  late TextEditingController _targetNicStrController;
  late TextEditingController _targetVGController;
  late TextEditingController _targetPGController;

  late TextEditingController _nicBaseNicStrController;
  late TextEditingController _nicBaseVGController;
  late TextEditingController _nicBasePGController;

  @override
  void initState() {
    _volumeController = TextEditingController(text: "30");

    _targetNicStrController = TextEditingController(text: "2");
    _targetVGController = TextEditingController(text: "40");
    _targetPGController = TextEditingController(text: "60");

    _nicBaseNicStrController = TextEditingController(text: "10");
    _nicBaseVGController = TextEditingController(text: "0");
    _nicBasePGController = TextEditingController(text: "100");

    ingredients = <Ingredient>[
      Ingredient(
        name: "Nicotine Base",
        percentage: _getNicBaseValues().$1,
        volume: _getNicBaseValues().$2,
        weight: _getNicBaseValues().$3,
        type: IngredientType.nicotine,
      ),
      Ingredient(
        name: "VG",
        percentage: _getVGValues().$1,
        volume: _getVGValues().$2,
        weight: _getVGValues().$3,
        type: IngredientType.vg,
      ),
      Ingredient(
        name: "PG",
        percentage: _getPGValues().$1,
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
    final double volume = _volumeController.text == ""
        ? 0.0
        : double.parse(_volumeController.text);

    final double targetNicStr =
        double.parse(_targetNicStrController.text) / 100;
    final double nicBaseNicStr =
        double.parse(_nicBaseNicStrController.text) / 100;

    double nicBaseVGVol = nicBaseCompVol(
      volume,
      targetNicStr,
      nicBaseNicStr,
      double.parse(_nicBaseVGController.text) / 100,
    );

    double nicBasePGVol = nicBaseCompVol(
      volume,
      targetNicStr,
      nicBaseNicStr,
      double.parse(_nicBasePGController.text) / 100,
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
    final double volume = _volumeController.text == ""
        ? 0.0
        : double.parse(_volumeController.text);

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
    final double volume = _volumeController.text == ""
        ? 0.0
        : double.parse(_volumeController.text);

    final double targetNicStr =
        double.parse(_targetNicStrController.text) / 100;
    final double nicBaseNicStr =
        double.parse(_nicBaseNicStrController.text) / 100;

    final vgFlavors = ingredients
        .where((ingredient) => ingredient.type == IngredientType.vgFlavor);

    double totalFlavVGPerc = vgFlavors.isNotEmpty
        ? vgFlavors.fold(0.0, (sum, flavor) => sum + flavor.percentage)
        : 0.0;

    double nicBaseVGPerc = _nicBaseVGController.text != ""
        ? double.parse(_nicBaseVGController.text) / 100
        : 0.0;

    double targetVG = _targetVGController.text != ""
        ? double.parse(_targetVGController.text) / 100
        : 0.0;

    double vgMixPerc = targetVG -
        totalFlavVGPerc +
        (targetNicStr *
            (nicBaseVGPerc - targetVG - (nicBaseVGPerc / nicBaseNicStr)));

    double ingredientVGVol = volume * vgMixPerc;

    return (vgMixPerc, ingredientVGVol, vgGrams(ingredientVGVol));
  }

  (double, double, double) _getPGValues() {
    final double volume = _volumeController.text == ""
        ? 0.0
        : double.parse(_volumeController.text);

    final double targetNicStr =
        double.parse(_targetNicStrController.text) / 100;
    final double nicBaseNicStr =
        double.parse(_nicBaseNicStrController.text) / 100;

    final pgFlavors = ingredients
        .where((ingredient) => ingredient.type == IngredientType.pgFlavor);

    double totalFlavPGPerc = pgFlavors.isNotEmpty
        ? pgFlavors.fold(0.0, (sum, flavor) => sum + flavor.percentage)
        : 0.0;

    double nicBasePGPerc = _nicBasePGController.text != ""
        ? double.parse(_nicBasePGController.text) / 100
        : 0.0;

    double targetPG = _targetPGController.text != ""
        ? double.parse(_targetPGController.text) / 100
        : 0.0;

    double pgMixPerc = targetPG -
        totalFlavPGPerc +
        (targetNicStr *
            (nicBasePGPerc - targetPG - (nicBasePGPerc / nicBaseNicStr)));

    double ingredientPGVol = volume * pgMixPerc;

    return (pgMixPerc, ingredientPGVol, pgGrams(ingredientPGVol));
  }

  void _updateValues() {
    for (Ingredient ingredient in ingredients) {
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
            ingredient.percentage,
          );
        case IngredientType.pgFlavor:
          (percentage, volume, weight) = _getFlavorValues(
            false,
            ingredient.percentage,
          );
      }

      setState(() {
        ingredient.percentage = percentage;
        ingredient.volume = volume;
        ingredient.weight = weight;
      });
    }
  }

  void _addEntry() {
    final flavor = 'Flavor ${_flavorEntries.length + 1}';
    const percentage = "0";

    final entry = FlavorEntry(
      flavor: flavor,
      percentage: percentage,
    );
    entry.flavorFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
    entry.percentageFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
    setState(() {
      _flavorEntries.add(entry);
      ingredients.insert(
        ingredients.length - 2,
        Ingredient(
          name: flavor,
          percentage: double.parse(percentage),
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
      ingredients.remove(
        ingredients.firstWhereOrNull((ingredient) => ingredient.id == entry.id),
      );
    });
    _updateValues();
  }

  Widget _buildEntryRow(FlavorEntry entry) {
    return Row(
      key: entry.id,
      spacing: 4.0,
      children: [
        IconButton(
          onPressed: () {
            _removeEntry(entry);
          },
          icon: const Icon(Icons.delete),
        ),
        Expanded(
          child: TextField(
            focusNode: entry.flavorFocusNode,
            controller: entry.flavorController,
            keyboardType: TextInputType.text,
            onSubmitted: (value) {
              final flavor = ingredients.firstWhereOrNull(
                (ingredient) => ingredient.id == entry.id,
              );
              if (flavor != null) {
                setState(() {
                  flavor.name = value;
                });
              }
            },
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF6CA0C4),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF0E76BD),
                ),
              ),
              filled: true,
              fillColor: Colors.white60,
              labelText: "Flavor",
              suffixIcon: !entry.flavorFocusNode.hasFocus
                  ? null
                  : entry.flavorController.text == ""
                      ? null
                      : Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Color.fromRGBO(0, 0, 0, .10),
                                  ),
                                  shape: WidgetStatePropertyAll(
                                    CircleBorder(),
                                  ),
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.all(12),
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                iconSize: 12,
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  setState(() {
                                    entry.flavorController.clear();
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                ),
                              ),
                            ],
                          ),
                        ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 8.0,
              ),
            ),
          ),
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 120),
          child: TextField(
            focusNode: entry.percentageFocusNode,
            controller: entry.percentageController,
            keyboardType: TextInputType.number,
            onSubmitted: (value) {
              final flavor = ingredients.firstWhereOrNull(
                (ingredient) => ingredient.id == entry.id,
              );
              if (flavor != null) {
                setState(() {
                  final (percentage, volume, weight) = _getFlavorValues(
                    entry.isVG,
                    double.parse(value) / 100,
                  );
                  flavor.percentage = percentage;
                  flavor.volume = volume;
                  flavor.weight = weight;
                });
                _updateValues();
              }
            },
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF6CA0C4),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF0E76BD),
                ),
              ),
              filled: true,
              fillColor: Colors.white60,
              labelText: "Percentage",
              suffix: entry.percentageFocusNode.hasFocus
                  ? null
                  : entry.percentageController.text == ""
                      ? null
                      : const Text("%"),
              suffixIcon: !entry.percentageFocusNode.hasFocus
                  ? null
                  : entry.percentageController.text == ""
                      ? null
                      : Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Color.fromRGBO(0, 0, 0, .10),
                                  ),
                                  shape: WidgetStatePropertyAll(
                                    CircleBorder(),
                                  ),
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.all(12),
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                iconSize: 12,
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  setState(() {
                                    entry.percentageController.text = "0";
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                ),
                              ),
                              const Text("%"),
                            ],
                          ),
                        ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 8.0,
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "VG",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Checkbox(
              value: entry.isVG,
              onChanged: (value) {
                setState(() {
                  entry.isVG = value ?? false;
                });
                final flavor = ingredients.firstWhereOrNull(
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
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    "DIY Mix",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const Gap(24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 30.0,
                runSpacing: 8.0,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20.0,
                    runSpacing: 8.0,
                    children: [
                      Column(
                        spacing: 8.0,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            margin: EdgeInsets.zero,
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              constraints: const BoxConstraints(
                                minWidth: 250,
                                maxWidth: 500,
                              ),
                              child: Column(
                                spacing: 12,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Batch",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextField(
                                    controller: _volumeController,
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) => _updateValues(),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF6CA0C4),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF0E76BD),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white60,
                                      labelText: "Volume",
                                      suffix: Text("mL"),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 8.0,
                                      ),
                                    ),
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
                                minWidth: 250,
                                maxWidth: 500,
                              ),
                              child: Column(
                                spacing: 12,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Flavoring",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Column(
                                    spacing: 8.0,
                                    children: [
                                      for (final entry in _flavorEntries)
                                        _buildEntryRow(entry)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          _addEntry();
                                        },
                                        child: const Text("+ Add"),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            margin: EdgeInsets.zero,
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              constraints: const BoxConstraints(
                                minWidth: 250,
                                maxWidth: 400,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Nic Base",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Gap(12),
                                  TextField(
                                    controller: _nicBaseNicStrController,
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) => _updateValues(),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF6CA0C4),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF0E76BD),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white60,
                                      labelText: "Nic Str",
                                      suffix: Text("%"),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 8.0,
                                      ),
                                    ),
                                  ),
                                  const Gap(8),
                                  Row(
                                    spacing: 8.0,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _nicBaseVGController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF6CA0C4),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF0E76BD),
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white60,
                                            labelText: "VG",
                                            suffix: Text("%"),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 8.0,
                                            ),
                                          ),
                                          onSubmitted: (value) {
                                            setState(() {
                                              _nicBasePGController.text =
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
                                        child: TextField(
                                          controller: _nicBasePGController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF6CA0C4),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF0E76BD),
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white60,
                                            labelText: "PG",
                                            suffix: Text("%"),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 8.0,
                                            ),
                                          ),
                                          onSubmitted: (value) {
                                            setState(() {
                                              _nicBaseVGController.text =
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
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            margin: EdgeInsets.zero,
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              constraints: const BoxConstraints(
                                minWidth: 250,
                                maxWidth: 400,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Target",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Gap(12),
                                  TextField(
                                    controller: _targetNicStrController,
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) {
                                      final percentage = double.parse(value);

                                      if (percentage == 0.0) {
                                        ingredients.removeAt(0);
                                      } else {
                                        if (!ingredients
                                            .map(
                                                (ingredient) => ingredient.name)
                                            .contains("Nicotine Base")) {
                                          setState(() {});
                                          final (percentage, volume, weight) =
                                              _getNicBaseValues();
                                          ingredients.insert(
                                            0,
                                            Ingredient(
                                              name: "Nicotine Base",
                                              percentage: percentage,
                                              volume: volume,
                                              weight: weight,
                                              type: IngredientType.nicotine,
                                            ),
                                          );
                                        }
                                      }
                                      _updateValues();
                                    },
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF6CA0C4),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF0E76BD),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white60,
                                      labelText: "Nic Str",
                                      suffix: Text("%"),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 8.0,
                                      ),
                                    ),
                                  ),
                                  const Gap(8),
                                  Row(
                                    spacing: 8.0,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _targetVGController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF6CA0C4),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF0E76BD),
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white60,
                                            labelText: "VG",
                                            suffix: Text("%"),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 8.0,
                                            ),
                                          ),
                                          onSubmitted: (value) {
                                            setState(() {
                                              _targetPGController.text =
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
                                        child: TextField(
                                          controller: _targetPGController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF6CA0C4),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF0E76BD),
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white60,
                                            labelText: "PG",
                                            suffix: Text("%"),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 8.0,
                                            ),
                                          ),
                                          onSubmitted: (value) {
                                            setState(() {
                                              _targetVGController.text =
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
                        ],
                      ),
                    ],
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    margin: EdgeInsets.zero,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      constraints: const BoxConstraints(
                        minWidth: 250,
                        maxWidth: 500,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Recipe",
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "%",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                numeric: true,
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
                              ...ingredients.map(
                                (ingredient) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        ingredient.name,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        '${(ingredient.percentage * 100).toStringAsFixed(2)} %',
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
                                      '${(ingredients.fold(0.0, (sum, ingredient) => sum + ingredient.percentage) * 100).toStringAsFixed(2)} %',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '${ingredients.fold(0.0, (sum, ingredient) => sum + ingredient.volume).toStringAsFixed(2)} mL',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '${ingredients.fold(0.0, (sum, ingredient) => sum + ingredient.weight).toStringAsFixed(2)} g',
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
