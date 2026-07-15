import 'dart:collection';

import 'package:elchemist_app/formulas.dart';
import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/ingredient.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/models/nic_profile.dart';
import 'package:elchemist_app/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MixView extends StatefulWidget {
  final Recipe recipe;

  const MixView({
    super.key,
    required this.recipe,
  });

  @override
  State<MixView> createState() => _MixViewState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _MixViewState extends State<MixView> {
  bool _isCustomChecked = false;
  String? selectedNicProfValue;
  NicProfile? nicProfile;

  late TextEditingController _volumeController;
  late TextEditingController _nicStrController;
  late TextEditingController _targetVGController;
  late TextEditingController _targetPGController;
  List<NicBase>? nicBases;
  List<Flavoring>? flavorings;

  final FocusNode _volumeFocusNode = FocusNode();
  String _prevVolumeText = "";
  bool _hasVolumeChanged = false;

  List<Ingredient> ingredients = <Ingredient>[];

  @override
  void initState() {
    _volumeController = TextEditingController();
    _nicStrController = TextEditingController();
    _targetVGController = TextEditingController();
    _targetPGController = TextEditingController();

    _volumeFocusNode.addListener(_handleVolumeFocusChange);
    super.initState();
  }

  void _handleVolumeFocusChange() {
    if (_volumeFocusNode.hasFocus) {
      _prevVolumeText = _volumeController.text;
      _volumeController.clear();
      _hasVolumeChanged = false;
    } else {
      if (!_hasVolumeChanged) {
        setState(() {
          _volumeController.text = _prevVolumeText;
        });
      }
    }
  }

  List<Ingredient> _populateIngredients() {
    ingredients = <Ingredient>[];
    final volume = double.parse(_volumeController.text);
    var nicotineVol = 0.0;
    var nicBaseVGVol = 0.0;
    var nicBasePGVol = 0.0;

    var targetVGVol = _volumeController.text != ""
        ? targetCompVol(volume, nicProfile!.targetNicStr, nicProfile!.targetVG)
        : 0.0;
    var targetPGVol = _volumeController.text != ""
        ? targetCompVol(volume, nicProfile!.targetNicStr, nicProfile!.targetPG)
        : 0.0;

    var flavVGVol = 0.0;
    var flavPGVol = 0.0;

    if (nicBases != null && nicBases!.isNotEmpty) {
      var nicBaseTitle =
          'Nicotine base ${nicBases?.map((nicBase) => '(${nicBase.code})').join(" / ")}';

      nicBaseVGVol = nicBases!.where((nicBase) => nicBase.isVg).fold(
            0.0,
            (sum, nicBase) =>
                sum +
                nicBaseCompVol(
                  volume,
                  nicProfile!.targetNicStr,
                  nicProfile!.nicBaseStr,
                  nicBase.percentage,
                ),
          );

      nicBasePGVol = nicBases!.where((nicBase) => !nicBase.isVg).fold(
            0.0,
            (sum, nicBase) =>
                sum +
                nicBaseCompVol(
                  volume,
                  nicProfile!.targetNicStr,
                  nicProfile!.nicBaseStr,
                  nicBase.percentage,
                ),
          );

      nicotineVol = nicVol(
        volume,
        nicProfile!.targetNicStr,
      );

      ingredients.add(
        Ingredient(
          name: nicBaseTitle,
          volume: nicotineVol + nicBasePGVol + nicBaseVGVol,
          weight: nicGrams(nicotineVol) +
              vgGrams(nicBaseVGVol) +
              pgGrams(nicBasePGVol),
        ),
      );
    }

    if (flavorings != null && flavorings!.isNotEmpty) {
      flavorings?.forEach(
        (flavoring) {
          var flavoringVol = flavVol(
            volume,
            flavoring.percentage,
          );

          ingredients.add(
            Ingredient(
              name: flavoring.name,
              volume: flavoringVol,
              weight: flavoring.isVG
                  ? vgFlavGrams(flavoringVol)
                  : pgFlavGrams(flavoringVol),
            ),
          );

          if (flavoring.isVG) {
            flavVGVol = flavVGVol + flavoringVol;
          } else {
            flavPGVol = flavPGVol + flavoringVol;
          }
        },
      );
    }

    var ingredientVGVol = mixRecipeComp(
      flavVGVol,
      targetVGVol,
      nicBaseVGVol,
    );
    ingredients.add(
      Ingredient(
        name: "VG",
        volume: ingredientVGVol,
        weight: vgGrams(ingredientVGVol),
      ),
    );

    var ingredientPGVol = mixRecipeComp(
      flavPGVol,
      targetPGVol,
      nicBasePGVol,
    );
    ingredients.add(
      Ingredient(
        name: "PG",
        volume: ingredientPGVol,
        weight: pgGrams(ingredientPGVol),
      ),
    );

    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = widget.recipe;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Mix",
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
                            initialSelection: selectedNicProfValue,
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
                              nicProfile = recipe.nicProfiles.firstWhere(
                                  (nicProfile) => nicProfile.name == value);
                              var nicStr = nicProfile!.targetNicStr * 100;
                              var targetVG = nicProfile!.targetVG * 100;
                              var targetPG = nicProfile!.targetPG * 100;

                              setState(() {
                                selectedNicProfValue = value;
                                _nicStrController.text = nicStr.toString();
                                _targetVGController.text =
                                    targetVG.toStringAsFixed(4);
                                _targetPGController.text =
                                    targetPG.toStringAsFixed(4);

                                nicBases = nicProfile!.nicBaseList;
                                flavorings = nicProfile!.flavoringList;
                              });

                              if (_volumeController.text == "") {
                                _volumeFocusNode.requestFocus();
                              } else {
                                setState(() {
                                  ingredients = _populateIngredients();
                                });
                              }
                            },
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: !_isCustomChecked,
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
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text(
                                "Custom?",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              value: _isCustomChecked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _isCustomChecked = newValue ?? false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),
                      selectedNicProfValue == null
                          ? const SizedBox.shrink()
                          : TextField(
                              focusNode: _volumeFocusNode,
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
                              onSubmitted: (value) {
                                setState(() {
                                  _volumeController.text = value;
                                  ingredients = _populateIngredients();
                                });
                                _hasVolumeChanged = value.isNotEmpty;
                              },
                            ),
                      selectedNicProfValue == null
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
                                  "Target",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  spacing: 12,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        readOnly: !_isCustomChecked,
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
                                        readOnly: !_isCustomChecked,
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
                      selectedNicProfValue == null || nicBases!.isEmpty
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
                                  "Nic Base",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ...nicBases!.map(
                                  (nicBase) => Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          readOnly: !_isCustomChecked,
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
                      selectedNicProfValue == null
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
                                  "Flavourings",
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
                                                    '${flavoring.percentage * 100}',
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
              _volumeController.text == ""
                  ? const SizedBox.shrink()
                  : Card(
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
                            const Text(
                              "Recipe",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(24),
                            DataTable(
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    "Ingredient",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                            )
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
