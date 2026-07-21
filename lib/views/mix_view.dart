import 'package:collection/collection.dart';
import 'package:elchemist_app/formulas.dart';
import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/ingredient.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/models/nic_profile.dart';
import 'package:elchemist_app/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NicBaseEntry {
  NicBaseEntry({
    String? nicBase,
    String? percentage,
    bool? isVG,
  })  : id = UniqueKey(),
        nicBaseController = TextEditingController(text: nicBase),
        percentageController = TextEditingController(text: percentage),
        isVG = isVG ?? false;

  final Key id;
  final TextEditingController nicBaseController;
  final TextEditingController percentageController;
  final FocusNode percentageFocusNode = FocusNode();
  bool isVG;

  void dispose() {
    nicBaseController.dispose();
    percentageController.dispose();
    percentageFocusNode.dispose();
  }

  String get code {
    final label = nicBaseController.text;
    final RegExp _labelPattern = RegExp(r'^(.*)\((.+)\)$');

    final match = _labelPattern.firstMatch(label.trim());
    if (match == null) return "";
    return match.group(2)!.trim();
  }
}

class NicBaseOption {
  final String code;
  final String name;
  final bool isVG;

  NicBaseOption({
    required this.code,
    required this.name,
    required this.isVG,
  });

  @override
  bool operator ==(other) => other is NicBaseOption && code == other.code;

  @override
  int get hashCode => Object.hash(code.hashCode, name.hashCode);

  String get label => '$name ($code)';

  @override
  String toString() => 'NicBaseOption: {label: $label, is_vg: $isVG"}';
}

class MixView extends StatefulWidget {
  final List<Recipe> recipes;

  const MixView({
    super.key,
    required this.recipes,
  });

  @override
  State<MixView> createState() => _MixViewState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _MixViewState extends State<MixView> {
  final List<NicBaseOption> _nicBaseOptions = [
    NicBaseOption(code: "1", name: "VG S", isVG: true),
    NicBaseOption(code: "2P", name: "PG S", isVG: false),
    NicBaseOption(code: "3P", name: "VG F", isVG: true),
    NicBaseOption(code: "1CNT", name: "VG S", isVG: true),
    NicBaseOption(code: "2CNT", name: "PG S", isVG: false),
  ];

  Recipe? _recipe;
  String? _selectedNicProfValue;
  NicProfile? _nicProfile;
  bool _isCustomChecked = false;

  late SearchController _searchController;
  late TextEditingController _volumeController;
  late TextEditingController _targetNicStrController;
  late TextEditingController _targetVGController;
  late TextEditingController _targetPGController;

  final List<NicBaseEntry> _nicBaseEntries = [];
  final List<Flavoring> _flavorings = [];

  final FocusNode _volumeFocusNode = FocusNode();
  String _prevVolumeText = "";
  bool _hasVolumeChanged = false;

  List<Ingredient> _ingredients = <Ingredient>[
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
  void initState() {
    _searchController = SearchController();
    _volumeController = TextEditingController();
    _targetNicStrController = TextEditingController(text: "0");
    _targetVGController = TextEditingController(text: "0");
    _targetPGController = TextEditingController(text: "0");

    _volumeFocusNode.addListener(_handleVolumeFocusChange);

    super.initState();
  }

  InputBorder _enabledBorder() => _isCustomChecked
      ? const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF6CA0C4),
          ),
        )
      : const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFDCDCDC),
          ),
        );
  InputBorder _focusedBorder() => _isCustomChecked
      ? const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF0E76BD),
          ),
        )
      : const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFDCDCDC),
          ),
        );

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

  (double, double, double) _getNicBaseValues() {
    final double volume = _volumeController.text == ""
        ? 0.0
        : double.parse(_volumeController.text);

    var nicotineVol = 0.0;
    var nicBaseVGVol = 0.0;
    var nicBasePGVol = 0.0;

    if (_nicBaseEntries.isNotEmpty) {
      nicBaseVGVol = _nicBaseEntries.where((nicBase) => nicBase.isVG).fold(
            0.0,
            (sum, nicBase) =>
                sum +
                nicBaseCompVol(
                  volume,
                  _nicProfile!.targetNicStr,
                  _nicProfile!.nicBaseStr,
                  double.parse(nicBase.percentageController.text),
                ),
          );

      nicBasePGVol = _nicBaseEntries.where((nicBase) => !nicBase.isVG).fold(
            0.0,
            (sum, nicBase) =>
                sum +
                nicBaseCompVol(
                  volume,
                  _nicProfile!.targetNicStr,
                  _nicProfile!.nicBaseStr,
                  double.parse(nicBase.percentageController.text),
                ),
          );

      nicotineVol = nicVol(
        volume,
        _nicProfile!.targetNicStr,
      );
    }

    return (
      _nicProfile != null
          ? _nicProfile!.targetNicStr / _nicProfile!.nicBaseStr
          : 0.0,
      nicotineVol + nicBasePGVol + nicBaseVGVol,
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

    final double nicStr = _nicProfile?.targetNicStr ?? 0.0;

    double totalFlavVGPerc = _flavorings
        .where((flavor) => flavor.isVG)
        .fold(0.0, (sum, flavor) => sum + flavor.percentage);

    double totalNicBaseVGPerc =
        _nicBaseEntries.where((nicBase) => nicBase.isVG).fold(
              0.0,
              (sum, nicBase) =>
                  sum + (double.parse(nicBase.percentageController.text) / 100),
            );

    double vgMixPerc = _nicProfile != null
        ? _nicProfile!.targetVG -
            totalFlavVGPerc +
            (nicStr *
                (totalNicBaseVGPerc -
                    _nicProfile!.targetVG -
                    (totalNicBaseVGPerc / _nicProfile!.nicBaseStr)))
        : 0.0;

    double ingredientVGVol = volume * vgMixPerc;

    return (vgMixPerc, ingredientVGVol, vgGrams(ingredientVGVol));
  }

  (double, double, double) _getPGValues() {
    final double volume = _volumeController.text == ""
        ? 0.0
        : double.parse(_volumeController.text);

    final double nicStr = _nicProfile?.targetNicStr ?? 0.0;

    double totalFlavPGPerc = _flavorings
        .where((flavor) => !flavor.isVG)
        .fold(0.0, (sum, flavor) => sum + flavor.percentage);

    double totalNicBasePGPerc = _nicBaseEntries
        .where((nicBase) => !nicBase.isVG)
        .fold(
            0.0,
            (sum, nicBase) =>
                sum + (double.parse(nicBase.percentageController.text) / 100));

    double pgMixPerc = _nicProfile != null
        ? _nicProfile!.targetPG -
            totalFlavPGPerc +
            (nicStr *
                (totalNicBasePGPerc -
                    _nicProfile!.targetPG -
                    (totalNicBasePGPerc / _nicProfile!.nicBaseStr)))
        : 0.0;

    double ingredientPGVol = volume * pgMixPerc;

    return (pgMixPerc, ingredientPGVol, pgGrams(ingredientPGVol));
  }

  List<Ingredient> _populateIngredients() {
    _ingredients = <Ingredient>[];

    if (_nicBaseEntries.isNotEmpty) {
      var nicBaseTitle =
          'Nicotine base${_nicBaseEntries.map((nicBase) => ' (${nicBase.code})').join(" / ")}';

      var (nicBasePercentage, nicBaseVolume, nicBaseweight) =
          _getNicBaseValues();

      _ingredients.add(
        Ingredient(
          name: nicBaseTitle,
          percentage: nicBasePercentage,
          volume: nicBaseVolume,
          weight: nicBaseweight,
          type: IngredientType.nicotine,
        ),
      );
    }

    if (_flavorings.isNotEmpty) {
      for (var flavoring in _flavorings) {
        var (flavoringPerc, flavoringVol, flavoringWeight) = _getFlavorValues(
          flavoring.isVG,
          flavoring.percentage,
        );

        _ingredients.add(
          Ingredient(
            name: flavoring.name,
            percentage: flavoring.percentage,
            volume: flavoringVol,
            weight: flavoringWeight,
            type: flavoring.isVG
                ? IngredientType.vgFlavor
                : IngredientType.pgFlavor,
          ),
        );
      }
    }

    final ingredientVG = _ingredients.firstWhereOrNull(
      (ingredient) => ingredient.name == "VG",
    );
    var (ingredientVGPerc, ingredientVGVol, ingredientVGWeight) =
        _getVGValues();

    if (ingredientVG != null) {
      ingredientVG.percentage = ingredientVGPerc;
      ingredientVG.volume = ingredientVGVol;
      ingredientVG.weight = ingredientVGWeight;
    } else {
      _ingredients.add(
        Ingredient(
          name: "VG",
          percentage: ingredientVGPerc,
          volume: ingredientVGVol,
          weight: ingredientVGWeight,
          type: IngredientType.vg,
        ),
      );
    }

    final ingredientPG = _ingredients.firstWhereOrNull(
      (ingredient) => ingredient.name == "PG",
    );
    var (ingredientPGPerc, ingredientPGVol, ingredientPGWeight) =
        _getPGValues();

    if (ingredientPG != null) {
      ingredientPG.percentage = ingredientPGPerc;
      ingredientPG.volume = ingredientPGVol;
      ingredientPG.weight = ingredientPGWeight;
    } else {
      _ingredients.add(
        Ingredient(
          name: "PG",
          percentage: ingredientPGPerc,
          volume: ingredientPGVol,
          weight: ingredientPGWeight,
          type: IngredientType.pg,
        ),
      );
    }

    return _ingredients;
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

  void _addEntry(NicBase? nicBase) {
    final entry = NicBaseEntry(
      nicBase: nicBase?.label ?? "",
      percentage: ((nicBase?.percentage ?? 0.0) * 100).toStringAsFixed(0),
    );
    entry.percentageFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
    setState(() {
      _nicBaseEntries.add(entry);
    });
    _updateValues();
  }

  void _removeEntry(NicBaseEntry entry) {
    setState(() {
      entry.dispose();
      _nicBaseEntries.remove(entry);
    });
    _updateValues();
  }

  Widget _buildEntryRow(NicBaseEntry entry) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _isCustomChecked && _nicBaseEntries.length > 1
            ? IconButton(
                onPressed: () => _removeEntry(entry),
                icon: const Icon(
                  Icons.delete,
                ),
              )
            : const SizedBox.shrink(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => IgnorePointer(
              ignoring: !_isCustomChecked,
              child: DropdownMenu<String>(
                width: constraints.maxWidth,
                selectOnly: true,
                initialSelection: _nicBaseOptions
                    .firstWhereOrNull(
                      (option) => option.label == entry.nicBaseController.text,
                    )
                    ?.label,
                controller: entry.nicBaseController,
                label: const Text('Name'),
                inputDecorationTheme: InputDecorationTheme(
                  enabledBorder: _enabledBorder(),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFDCDCDC),
                    ),
                  ),
                  focusedBorder: _focusedBorder(),
                  filled: _isCustomChecked,
                  fillColor: _isCustomChecked ? Colors.white60 : null,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8.0,
                  ),
                ),
                dropdownMenuEntries: UnmodifiableListView<MenuEntry>(
                  _nicBaseOptions.map<MenuEntry>(
                    (option) => MenuEntry(
                      value: option.code,
                      label: option.label,
                    ),
                  ),
                ),
                onSelected: (value) {
                  final nicBaseOption = _nicBaseOptions.firstWhere(
                    (option) => option.code == value,
                  );
                  setState(() {
                    entry.isVG = nicBaseOption.isVG;
                  });
                },
              ),
            ),
          ),
        ),
        const Gap(8),
        Container(
          constraints: const BoxConstraints(maxWidth: 120),
          child: TextField(
            readOnly: !_isCustomChecked,
            controller: entry.percentageController,
            onSubmitted: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              enabledBorder: _enabledBorder(),
              focusedBorder: _focusedBorder(),
              filled: _isCustomChecked,
              fillColor: _isCustomChecked ? Colors.white60 : null,
              labelText: "Percentage",
              suffix: const Text("%"),
              contentPadding: const EdgeInsets.symmetric(
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
              value: entry.isVG,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Recipe> recipes = widget.recipes;

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
                    "Search and Mix",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const Gap(24),
              Wrap(
                spacing: 30.0,
                runSpacing: 8.0,
                children: [
                  Wrap(
                    spacing: 20.0,
                    runSpacing: 8.0,
                    children: [
                      Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            margin: EdgeInsets.zero,
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              constraints: const BoxConstraints(
                                  minWidth: 500, maxWidth: 500),
                              child: _recipe == null
                                  ? SearchAnchor(
                                      searchController: _searchController,
                                      viewShape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4.0),
                                        ),
                                      ),
                                      viewSide: const BorderSide(
                                        color: Color(0xFF0E76BD),
                                      ),
                                      builder: (context, controller) {
                                        return SearchBar(
                                          controller: controller,
                                          onTap: () {
                                            controller.openView();
                                          },
                                          onChanged: (value) {
                                            controller.openView();
                                          },
                                          leading: const Icon(Icons.search),
                                          elevation:
                                              const WidgetStatePropertyAll(0.0),
                                          shape: const WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Color(0xFF6CA0C4),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(4.0),
                                              ),
                                            ),
                                          ),
                                          backgroundColor:
                                              const WidgetStatePropertyAll(
                                            Colors.white,
                                          ),
                                        );
                                      },
                                      suggestionsBuilder:
                                          (context, controller) {
                                        final String input =
                                            controller.value.text.toLowerCase();
                                        final Iterable<Recipe>
                                            filteredSuggestions =
                                            recipes.where((recipeItem) {
                                          return recipeItem.name
                                              .toLowerCase()
                                              .contains(input);
                                        });

                                        return filteredSuggestions
                                            .map((suggestionItem) {
                                          return ListTile(
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  suggestionItem.brand
                                                      .toUpperCase(),
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
                                                controller.closeView(
                                                    suggestionItem.name);
                                                _recipe = suggestionItem;
                                              });
                                            },
                                          );
                                        });
                                      },
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  _recipe!.brand.toUpperCase(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  _recipe!.name,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '${_recipe!.nicType.toString()} — ${_recipe!.chilltype.toString()}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.change_circle_sharp,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _recipe = null;
                                                  _selectedNicProfValue = null;
                                                  _nicProfile = null;
                                                  _searchController.clear();
                                                  _volumeController.clear();
                                                  _targetNicStrController
                                                      .clear();
                                                });
                                              },
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
                                              initialSelection:
                                                  _selectedNicProfValue,
                                              inputDecorationTheme:
                                                  const InputDecorationTheme(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xFF6CA0C4),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xFF0E76BD),
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white60,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 8.0,
                                                ),
                                              ),
                                              dropdownMenuEntries:
                                                  UnmodifiableListView<
                                                      MenuEntry>(
                                                _recipe!.nicProfiles
                                                    .map<MenuEntry>(
                                                  (nicProfile) => MenuEntry(
                                                    value: nicProfile.name,
                                                    label:
                                                        '${nicProfile.name} (${nicProfile.isNewMix ? 'New Mix' : 'Old Mix'})',
                                                  ),
                                                ),
                                              ),
                                              onSelected: (String? value) {
                                                _nicProfile = _recipe!
                                                    .nicProfiles
                                                    .firstWhere((nicProfile) =>
                                                        nicProfile.name ==
                                                        value);
                                                var nicStr =
                                                    _nicProfile!.targetNicStr *
                                                        100;
                                                var targetVG =
                                                    _nicProfile!.targetVG * 100;
                                                var targetPG =
                                                    _nicProfile!.targetPG * 100;

                                                setState(() {
                                                  _selectedNicProfValue = value;
                                                  _targetNicStrController.text =
                                                      nicStr.toString();
                                                  _targetVGController.text =
                                                      targetVG
                                                          .toStringAsFixed(4);
                                                  _targetPGController.text =
                                                      targetPG
                                                          .toStringAsFixed(4);

                                                  _nicBaseEntries.clear();

                                                  for (var nicBase
                                                      in _nicProfile!
                                                          .nicBaseList) {
                                                    _addEntry(nicBase);
                                                  }

                                                  _flavorings.clear();

                                                  _flavorings.addAll(
                                                    _nicProfile!.flavoringList,
                                                  );

                                                  _ingredients =
                                                      _populateIngredients();
                                                });

                                                if (_volumeController.text ==
                                                    "") {
                                                  _volumeFocusNode
                                                      .requestFocus();
                                                }
                                              },
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  "Custom?",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Checkbox(
                                                  value: _isCustomChecked,
                                                  side: const BorderSide(
                                                    color: Color(0xFF6CA0C4),
                                                  ),
                                                  onChanged: (bool? newValue) {
                                                    setState(() {
                                                      _isCustomChecked =
                                                          newValue ?? false;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Gap(12),
                                        _selectedNicProfValue == null
                                            ? const SizedBox.shrink()
                                            : TextField(
                                                focusNode: _volumeFocusNode,
                                                controller: _volumeController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFF6CA0C4),
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFF0E76BD),
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white60,
                                                  labelText: "Volume",
                                                  suffix: Text("mL"),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 8.0,
                                                  ),
                                                ),
                                                onSubmitted: (value) {
                                                  if (value.isEmpty) {
                                                    _volumeController.text =
                                                        _prevVolumeText;
                                                    return;
                                                  }

                                                  setState(() {
                                                    // _volumeController.text = value;
                                                    _ingredients =
                                                        _populateIngredients();
                                                  });
                                                  _hasVolumeChanged =
                                                      value.isNotEmpty;
                                                },
                                              ),
                                      ],
                                    ),
                            ),
                          ),
                          const Gap(8.0),
                          _selectedNicProfValue == null
                              ? const SizedBox.shrink()
                              : Card(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Flavouring",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ..._flavorings.map(
                                          (flavoring) => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  readOnly: true,
                                                  controller:
                                                      TextEditingController(
                                                    text: flavoring.name,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0xFFDCDCDC),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0xFFDCDCDC),
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
                                                    constraints:
                                                        const BoxConstraints(
                                                      maxWidth: 120,
                                                    ),
                                                    child: TextField(
                                                      readOnly:
                                                          !_isCustomChecked,
                                                      controller:
                                                          TextEditingController(
                                                        text: (flavoring
                                                                    .percentage *
                                                                100)
                                                            .toStringAsFixed(4),
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            _enabledBorder(),
                                                        focusedBorder:
                                                            _focusedBorder(),
                                                        filled:
                                                            _isCustomChecked,
                                                        fillColor:
                                                            _isCustomChecked
                                                                ? Colors.white60
                                                                : null,
                                                        labelText: "Percentage",
                                                        suffix: const Text("%"),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
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
                                    readOnly: true,
                                    controller: TextEditingController(
                                      text: ((_nicProfile?.nicBaseStr ?? 0.0) *
                                              100)
                                          .toStringAsFixed(0),
                                    ),
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
                                          readOnly: true,
                                          controller: TextEditingController(
                                            text: (_nicBaseEntries
                                                        .where((entry) =>
                                                            entry.isVG)
                                                        .fold(
                                                          0.0,
                                                          (sum, entry) =>
                                                              sum +
                                                              (double.parse(entry
                                                                      .percentageController
                                                                      .text) /
                                                                  100),
                                                        ) *
                                                    100)
                                                .toStringAsFixed(0),
                                          ),
                                          onChanged: (value) => _updateValues(),
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
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: (_nicBaseEntries
                                                          .where((entry) =>
                                                              !entry.isVG)
                                                          .fold(
                                                            0.0,
                                                            (sum, entry) =>
                                                                sum +
                                                                (double.parse(entry
                                                                        .percentageController
                                                                        .text) /
                                                                    100),
                                                          ) *
                                                      100)
                                                  .toStringAsFixed(0)),
                                          onChanged: (value) => _updateValues(),
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
                                  _nicBaseEntries.isEmpty
                                      ? const SizedBox.shrink()
                                      : Column(
                                          children: [
                                            const Gap(8.0),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[350],
                                            ),
                                            const Gap(8.0),
                                            ..._nicBaseEntries.map(
                                              (entry) => _buildEntryRow(entry),
                                            ),
                                          ],
                                        ),
                                  _isCustomChecked
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () => _addEntry(null),
                                              child: const Text("+ Add"),
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
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
                                    readOnly: !_isCustomChecked,
                                    controller: _targetNicStrController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      enabledBorder: _enabledBorder(),
                                      focusedBorder: _focusedBorder(),
                                      filled: _isCustomChecked,
                                      fillColor: _isCustomChecked
                                          ? Colors.white60
                                          : null,
                                      labelText: "Nic Str",
                                      suffix: const Text("%"),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                          readOnly: !_isCustomChecked,
                                          controller: _targetVGController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            enabledBorder: _enabledBorder(),
                                            focusedBorder: _focusedBorder(),
                                            filled: _isCustomChecked,
                                            fillColor: _isCustomChecked
                                                ? Colors.white60
                                                : null,
                                            labelText: "VG",
                                            suffix: const Text("%"),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
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
                                          decoration: InputDecoration(
                                            enabledBorder: _enabledBorder(),
                                            focusedBorder: _focusedBorder(),
                                            filled: _isCustomChecked,
                                            fillColor: _isCustomChecked
                                                ? Colors.white60
                                                : null,
                                            labelText: "PG",
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
                      borderRadius: BorderRadius.circular(
                        4.0,
                      ),
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
                                      '${(_ingredients.fold(0.0, (sum, ingredient) => sum + ingredient.percentage) * 100).toStringAsFixed(2)} %',
                                      style: const TextStyle(
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
