import 'dart:collection';

import 'package:elchemist_app/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeView extends StatefulWidget {
  final Recipe recipe;

  const RecipeView({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _RecipeViewState extends State<RecipeView> {
  late TextEditingController _batchController;
  late TextEditingController _nicController;
  late TextEditingController _targetVGController;
  late TextEditingController _targetPGController;
  late TextEditingController _nicBaseVGController;
  late TextEditingController _nicBasePGController;

  @override
  void initState() {
    _batchController = TextEditingController();
    _nicController = TextEditingController();
    _targetVGController = TextEditingController();
    _targetPGController = TextEditingController();
    _nicBaseVGController = TextEditingController();
    _nicBasePGController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.recipe.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 48,
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownMenu<String>(
                  dropdownMenuEntries: UnmodifiableListView<MenuEntry>(
                    recipe.settingsByNic?.map<MenuEntry>(
                          (setting) => MenuEntry(
                            value: setting.nicStrength,
                            label: setting.nicStrength,
                          ),
                        ) ??
                        [],
                  ),
                ),
                TextField(
                  controller: _batchController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Batch",
                  ),
                ),
                TextField(
                  controller: _nicController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nic Strength",
                  ),
                ),
                Row(
                  children: [
                    TextField(
                      controller: _targetVGController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Batch",
                      ),
                    ),
                    TextField(
                      controller: _targetPGController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Batch",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextField(
                      controller: _nicBaseVGController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Batch",
                      ),
                    ),
                    TextField(
                      controller: _nicBasePGController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Batch",
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
