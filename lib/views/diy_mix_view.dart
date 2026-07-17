import 'package:elchemist_app/models/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FlavorEntry {
  FlavorEntry({String? flavor, String? percentage})
      : id = UniqueKey(),
        flavorController = TextEditingController(text: flavor),
        percentageController = TextEditingController(text: percentage);

  final Key id;
  final TextEditingController flavorController;
  final TextEditingController percentageController;
  bool isVG = false;

  void dispose() {
    flavorController.dispose();
    percentageController.dispose();
  }
}

class DiyMixView extends StatefulWidget {
  const DiyMixView({super.key});

  @override
  State<DiyMixView> createState() => _DiyMixViewState();
}

class _DiyMixViewState extends State<DiyMixView> {
  List<Ingredient> ingredients = <Ingredient>[
    Ingredient(
      name: "VG",
      percentage: 0.0,
      volume: 0.0,
      weight: 0.0,
      type: IngredientType.vg,
    ),
    Ingredient(
      name: "PG",
      percentage: 0.0,
      volume: 0.0,
      weight: 0.0,
      type: IngredientType.pg,
    ),
  ];

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
    _volumeController = TextEditingController();

    _targetNicStrController = TextEditingController(text: "2");
    _targetVGController = TextEditingController(text: "40");
    _targetPGController = TextEditingController(text: "60");

    _nicBaseNicStrController = TextEditingController(text: "10");
    _nicBaseVGController = TextEditingController(text: "0");
    _nicBasePGController = TextEditingController(text: "100");

    super.initState();
  }

  int _getDecimalPlaces(String value) {
    double doubleValue = double.parse(value);

    if (doubleValue == doubleValue.toInt()) return 0;

    List<String> parts = value.split('.');

    return parts.length > 1 ? parts[1].length : 0;
  }

  void _addEntry() {
    setState(() {
      _flavorEntries.add(
        FlavorEntry(
          flavor: 'Flavor ${_flavorEntries.length + 1}',
          percentage: "0",
        ),
      );
    });
  }

  void _removeEntry(FlavorEntry entry) {
    setState(() {
      entry.dispose();
      _flavorEntries.remove(entry);
    });
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
            controller: entry.flavorController,
            keyboardType: TextInputType.text,
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
              labelText: "Flavor",
              contentPadding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 8.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: entry.percentageController,
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
              labelText: "Percentage",
              suffix: Text("%"),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 8.0,
              ),
            ),
          ),
        ),
        Checkbox(
          value: entry.isVG,
          onChanged: (value) {
            setState(() {
              entry.isVG = value ?? false;
            });
          },
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 32.0,
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
                                  minWidth: 500,
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
                                  minWidth: 500,
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
                                  minWidth: 400,
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
                                                _nicBaseVGController.text =
                                                    value;
                                                _nicBasePGController
                                                    .text = (100 -
                                                        (double.parse(value)))
                                                    .toStringAsFixed(
                                                  _getDecimalPlaces(
                                                    value,
                                                  ),
                                                );
                                              });
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
                                                _nicBasePGController.text =
                                                    value;
                                                _nicBaseVGController
                                                    .text = (100 -
                                                        (double.parse(value)))
                                                    .toStringAsFixed(
                                                  _getDecimalPlaces(
                                                    value,
                                                  ),
                                                );
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
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              margin: EdgeInsets.zero,
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                constraints: const BoxConstraints(
                                  minWidth: 400,
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
                                                _targetVGController.text =
                                                    value;
                                                _targetPGController
                                                    .text = (100 -
                                                        (double.parse(value)))
                                                    .toStringAsFixed(
                                                  _getDecimalPlaces(
                                                    value,
                                                  ),
                                                );
                                              });
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
                                                _targetPGController.text =
                                                    value;
                                                _targetVGController
                                                    .text = (100 -
                                                        (double.parse(value)))
                                                    .toStringAsFixed(
                                                  _getDecimalPlaces(
                                                    value,
                                                  ),
                                                );
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(8.0),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    margin: EdgeInsets.zero,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      constraints: const BoxConstraints(
                        minWidth: 500,
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
