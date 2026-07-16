import 'package:elchemist_app/models/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: EdgeInsets.zero,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            constraints: const BoxConstraints(
                                minWidth: 420, maxWidth: 420),
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
                                    minWidth: 420, maxWidth: 420),
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
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
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
                                    minWidth: 420, maxWidth: 420),
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
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
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
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    margin: EdgeInsets.zero,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      constraints:
                          const BoxConstraints(minWidth: 500, maxWidth: 500),
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
