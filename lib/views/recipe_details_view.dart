import 'dart:collection';

import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/models/nic_profile.dart';
import 'package:elchemist_app/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RecipeDetailsView extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsView({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeDetailsView> createState() => _RecipeDetailsViewState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _RecipeDetailsViewState extends State<RecipeDetailsView> {
  String? _selectedNicProfValue;
  NicProfile? _nicProfile;
  List<NicBase>? nicBases;
  List<Flavoring>? flavorings;

  late TextEditingController _nicStrController;
  late TextEditingController _targetVGController;
  late TextEditingController _targetPGController;

  @override
  void initState() {
    _nicStrController = TextEditingController();
    _targetVGController = TextEditingController();
    _targetPGController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = widget.recipe;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Recipe",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    4.0,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            recipe.brand.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            recipe.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${recipe.nicType.toString()} — ${recipe.chilltype.toString()}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Gap(24),
                      Row(
                        spacing: 12,
                        children: [
                          DropdownMenu<String>(
                            selectOnly: true,
                            label: const Text('Profile'),
                            initialSelection: _selectedNicProfValue,
                            inputDecorationTheme: const InputDecorationTheme(
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
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8.0,
                              ),
                            ),
                            dropdownMenuEntries:
                                UnmodifiableListView<MenuEntry>(
                              recipe.nicProfiles.map<MenuEntry>(
                                (nicProfile) => MenuEntry(
                                  value: nicProfile.name,
                                  label:
                                      '${nicProfile.name} (${nicProfile.isNewMix ? 'New Mix' : 'Old Mix'})',
                                ),
                              ),
                            ),
                            onSelected: (String? value) {
                              _nicProfile = recipe.nicProfiles.firstWhere(
                                  (nicProfile) => nicProfile.name == value);
                              var nicStr = _nicProfile!.targetNicStr * 100;
                              var targetVG = _nicProfile!.targetVG * 100;
                              var targetPG = _nicProfile!.targetPG * 100;

                              setState(() {
                                _selectedNicProfValue = value;
                                _nicStrController.text = nicStr.toString();
                                _targetVGController.text =
                                    targetVG.toStringAsFixed(4);
                                _targetPGController.text =
                                    targetPG.toStringAsFixed(4);

                                nicBases = _nicProfile!.nicBaseList;
                                flavorings = _nicProfile!.flavoringList;
                              });
                            },
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              controller: _nicStrController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFDCDCDC),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFDCDCDC),
                                  ),
                                ),
                                labelText: "Nic Strength",
                                suffix: Text("%"),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 8.0,
                                ),
                              ),
                              onSubmitted: (value) {
                                setState(() {
                                  _nicStrController.text = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),
                      _selectedNicProfValue == null
                          ? const SizedBox.shrink()
                          : Column(
                              spacing: 12,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(12),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey[350],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Target",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Nic Str: ${(_nicProfile!.targetNicStr * 100).toStringAsFixed(2)}%',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 12,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        readOnly: true,
                                        controller: _targetVGController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFDCDCDC),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFDCDCDC),
                                            ),
                                          ),
                                          labelText: "VG",
                                          suffix: Text("%"),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 0,
                                            horizontal: 8.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        readOnly: true,
                                        controller: _targetPGController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFDCDCDC),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFFDCDCDC),
                                            ),
                                          ),
                                          labelText: "PG",
                                          suffix: Text("%"),
                                          contentPadding: EdgeInsets.symmetric(
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
                      _selectedNicProfValue == null || nicBases!.isEmpty
                          ? const SizedBox.shrink()
                          : Column(
                              spacing: 12,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(12),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey[350],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Nic Base",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Nic Str: ${(_nicProfile!.nicBaseNicStr * 100).toStringAsFixed(2)}%',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                ...nicBases!.map(
                                  (nicBase) => Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          readOnly: true,
                                          controller: TextEditingController(
                                            text: (nicBase.percentage * 100)
                                                .toStringAsFixed(0),
                                          ),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFDCDCDC),
                                              ),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFDCDCDC),
                                              ),
                                            ),
                                            labelText:
                                                '${nicBase.name} (${nicBase.code})',
                                            suffix: const Text("%"),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 8.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      _selectedNicProfValue == null
                          ? const SizedBox.shrink()
                          : Column(
                              spacing: 12,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(12),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey[350],
                                ),
                                const Text(
                                  "Flavouring",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ...flavorings!.map(
                                  (flavoring) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          readOnly: true,
                                          controller: TextEditingController(
                                            text: flavoring.name,
                                          ),
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFDCDCDC),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFDCDCDC),
                                              ),
                                            ),
                                            labelText: "Name",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 8.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(8),
                                      Row(
                                        children: [
                                          Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 120),
                                            child: TextField(
                                              readOnly: true,
                                              controller: TextEditingController(
                                                text:
                                                    (flavoring.percentage * 100)
                                                        .toStringAsFixed(4),
                                              ),
                                              decoration: const InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xFFDCDCDC),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xFFDCDCDC),
                                                  ),
                                                ),
                                                labelText: "Percentage",
                                                suffix: Text("%"),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  vertical: 0,
                                                  horizontal: 8.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              const Text("VG"),
                                              Checkbox(
                                                value: flavoring.isVG,
                                                onChanged: null,
                                                side: const BorderSide(
                                                  color: Color(
                                                    0xFFB0B0B0,
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
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
