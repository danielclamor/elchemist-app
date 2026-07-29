import 'package:collection/collection.dart';
import 'package:elchemist_app/components/atoms/el_checkbox.dart';
import 'package:elchemist_app/components/atoms/el_dropdown_menu.dart';
import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/constants.dart';
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
    NicBase? nicBase,
    bool? isVG,
  })  : id = UniqueKey(),
        nicBase = nicBase,
        nicBaseController = TextEditingController(
          text: nicBase?.label,
        ),
        percentageController = TextEditingController(
          text: ((nicBase?.percentage ?? 0.0) * 100).toStringAsFixed(0),
        ),
        isVG = isVG ?? false;

  final Key id;
  final NicBase? nicBase;
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
    final RegExp labelPattern = RegExp(r'^(.*)\((.+)\)$');

    final match = labelPattern.firstMatch(label.trim());
    if (match == null) return "";
    return match.group(2)!.trim();
  }
}

class SearchMixView extends StatefulWidget {
  final List<Recipe> recipes;

  const SearchMixView({
    super.key,
    required this.recipes,
  });

  @override
  State<SearchMixView> createState() => _SearchMixViewState();
}

class _SearchMixViewState extends State<SearchMixView> {
  final List<NicBaseOption> _nicBaseOptions = nicBaseOptionsData
      .map((option) => NicBaseOption.fromMap(option))
      .toList();

  Recipe? _recipe;
  String? _selectedNicProfValue;
  NicProfile? _nicProfile;
  bool _isCustomChecked = false;

  late SearchController _searchController;
  late TextEditingController _volumeController;
  late TextEditingController _targetNicStrController;
  late TextEditingController _targetVGController;
  late TextEditingController _targetPGController;
  late TextEditingController _nicBaseNicStrController;
  late TextEditingController _nicBaseVGController;
  late TextEditingController _nicBasePGController;

  List<TextEditingController> get _allControllers => [
        _searchController,
        _volumeController,
        _targetNicStrController,
        _targetVGController,
        _targetPGController,
        _nicBaseNicStrController,
        _nicBaseVGController,
        _nicBasePGController,
      ];

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
    _nicBaseNicStrController = TextEditingController(text: "0");
    _nicBaseVGController = TextEditingController(text: "0");
    _nicBasePGController = TextEditingController(text: "0");

    _volumeFocusNode.addListener(_handleVolumeFocusChange);

    super.initState();
  }

  @override
  void dispose() {
    for (final c in _allControllers) {
      c.dispose();
    }

    super.dispose();
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

    final double targetNicStr = _targetNicStrController.text != ""
        ? double.parse(_targetNicStrController.text) / 100
        : 0.0;

    final double nicBaseNicStr = _nicBaseNicStrController.text != ""
        ? double.parse(_nicBaseNicStrController.text) / 100
        : 0.0;

    double nicBaseVGVol = _nicBaseEntries.where((nicBase) => nicBase.isVG).fold(
          0.0,
          (sum, nicBase) =>
              sum +
              nicBaseCompVol(
                volume,
                targetNicStr,
                nicBaseNicStr,
                double.parse(nicBase.percentageController.text) / 100,
              ),
        );

    double nicBasePGVol =
        _nicBaseEntries.where((nicBase) => !nicBase.isVG).fold(
              0.0,
              (sum, nicBase) =>
                  sum +
                  nicBaseCompVol(
                    volume,
                    targetNicStr,
                    nicBaseNicStr,
                    double.parse(nicBase.percentageController.text) / 100,
                  ),
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

    final double targetNicStr = _targetNicStrController.text != ""
        ? double.parse(_targetNicStrController.text) / 100
        : 0.0;

    final double targetVG = _targetVGController.text != ""
        ? double.parse(_targetVGController.text) / 100
        : 0.0;

    final double nicBaseNicStr = _nicBaseNicStrController.text != ""
        ? double.parse(_nicBaseNicStrController.text) / 100
        : 0.0;

    double totalFlavVGPerc = _ingredients
        .where((ingredient) => ingredient.type == IngredientType.vgFlavor)
        .fold(0.0, (sum, flavor) => sum + flavor.percentage);

    double nicBaseVGPerc =
        _nicBaseEntries.where((nicBase) => nicBase.isVG).fold(
              0.0,
              (sum, nicBase) =>
                  sum + (double.parse(nicBase.percentageController.text) / 100),
            );

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

    final double targetNicStr = _targetNicStrController.text != ""
        ? double.parse(_targetNicStrController.text) / 100
        : 0.0;

    final double targetPG = _targetPGController.text != ""
        ? double.parse(_targetPGController.text) / 100
        : 0.0;

    final double nicBaseNicStr = _nicBaseNicStrController.text != ""
        ? double.parse(_nicBaseNicStrController.text) / 100
        : 0.0;

    final double totalFlavPGPerc = _ingredients
        .where((ingredient) => ingredient.type == IngredientType.pgFlavor)
        .fold(0.0, (sum, flavor) => sum + flavor.percentage);

    final double nicBasePGPerc =
        _nicBaseEntries.where((nicBase) => !nicBase.isVG).fold(
              0.0,
              (sum, nicBase) =>
                  sum + (double.parse(nicBase.percentageController.text) / 100),
            );

    final double pgMixPerc = targetPG -
        totalFlavPGPerc +
        (targetNicStr *
            (nicBasePGPerc - targetPG - (nicBasePGPerc / nicBaseNicStr)));

    final double ingredientPGVol = volume * pgMixPerc;

    return (pgMixPerc, ingredientPGVol, pgGrams(ingredientPGVol));
  }

  void _changeRecipe() {
    setState(() {
      _recipe = null;
      _selectedNicProfValue = null;
      _nicProfile = null;
      _nicBaseEntries.clear();
      _isCustomChecked = false;
      _ingredients = <Ingredient>[
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

      for (final c in _allControllers) {
        c.clear();
      }
    });
  }

  void _onSelectNicProfile(String? value) {
    var nicStr = _nicProfile!.targetNicStr * 100;
    var targetVG = _nicProfile!.targetVG * 100;
    var targetPG = _nicProfile!.targetPG * 100;
    var nicBaseNicStr = _nicProfile!.nicBaseNicStr * 100;

    setState(() {
      _selectedNicProfValue = value;
      _targetNicStrController.text = nicStr.toStringAsFixed(2);
      _targetVGController.text = targetVG.toStringAsFixed(4);
      _targetPGController.text = targetPG.toStringAsFixed(4);
      _nicBaseNicStrController.text = nicBaseNicStr.toStringAsFixed(0);
      _nicBaseEntries.clear();

      for (var nicBase in _nicProfile!.nicBases) {
        _addEntry(nicBase);
      }

      _nicBaseVGController
          .text = (_nicBaseEntries.where((entry) => entry.isVG).fold(
                    0.0,
                    (sum, entry) =>
                        sum +
                        (double.parse(entry.percentageController.text) / 100),
                  ) *
              100)
          .toStringAsFixed(0);

      _nicBasePGController
          .text = (_nicBaseEntries.where((entry) => !entry.isVG).fold(
                    0.0,
                    (sum, entry) =>
                        sum +
                        (double.parse(entry.percentageController.text) / 100),
                  ) *
              100)
          .toStringAsFixed(0);

      _flavorings.clear();

      _flavorings.addAll(
        _nicProfile!.flavorings,
      );

      _ingredients = _populateIngredients();
    });
  }

  Ingredient get _nicBaseIngredient {
    var nicBaseTitle =
        'Nicotine base${_nicBaseEntries.map((nicBase) => ' (${nicBase.code})').join(" / ")}';

    var (nicBasePercentage, nicBaseVolume, nicBaseweight) = _getNicBaseValues();

    return Ingredient(
      name: nicBaseTitle,
      percentage: nicBasePercentage,
      volume: nicBaseVolume,
      weight: nicBaseweight,
      type: IngredientType.nicotine,
    );
  }

  List<Ingredient> _populateIngredients() {
    _ingredients.removeRange(0, _ingredients.length - 2);

    if (_nicBaseEntries.isNotEmpty) {
      _ingredients.insert(
        0,
        _nicBaseIngredient,
      );
    }

    if (_flavorings.isNotEmpty) {
      for (var flavoring in _flavorings) {
        var (flavoringPerc, flavoringVol, flavoringWeight) = _getFlavorValues(
          flavoring.isVG,
          flavoring.percentage,
        );

        _ingredients.insert(
          _ingredients.length - 2,
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

    final ingredientVG = _ingredients[_ingredients.length - 2];
    var (ingredientVGPerc, ingredientVGVol, ingredientVGWeight) =
        _getVGValues();
    ingredientVG.percentage = ingredientVGPerc;
    ingredientVG.volume = ingredientVGVol;
    ingredientVG.weight = ingredientVGWeight;

    final ingredientPG = _ingredients[_ingredients.length - 1];
    var (ingredientPGPerc, ingredientPGVol, ingredientPGWeight) =
        _getPGValues();
    ingredientPG.percentage = ingredientPGPerc;
    ingredientPG.volume = ingredientPGVol;
    ingredientPG.weight = ingredientPGWeight;

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
      nicBase: nicBase,
      isVG: nicBase?.isVG,
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

  Widget _buildEntryRow(NicBaseEntry entry, bool withHeaders) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _isCustomChecked && _nicBaseEntries.length > 1
            ? Padding(
                padding: EdgeInsets.only(top: withHeaders ? 28.0 : 4.0),
                child: IconButton(
                  onPressed: () => _removeEntry(entry),
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => ElDropdownMenu<NicBaseOption>(
              width: constraints.maxWidth,
              ignoring: !_isCustomChecked,
              initialSelection: _nicBaseOptions.firstWhereOrNull(
                (option) => option == entry.nicBase?.nicBase,
              ),
              labelText: withHeaders ? 'Name' : null,
              dropdownMenuEntries:
                  UnmodifiableListView<DropdownMenuEntry<NicBaseOption>>(
                _nicBaseOptions.map<DropdownMenuEntry<NicBaseOption>>(
                  (option) => DropdownMenuEntry<NicBaseOption>(
                    value: option,
                    label: option.label,
                  ),
                ),
              ),
              onSelected: (value) {
                final nicBaseOption = value;
                setState(() {
                  entry.isVG = nicBaseOption?.isVG ?? false;
                  _ingredients[0] = _nicBaseIngredient;
                  _nicBaseVGController.text = (_nicBaseEntries
                              .where((nicBaseEntry) => nicBaseEntry.isVG)
                              .fold(
                                0.0,
                                (sum, nicBaseEntry) =>
                                    sum +
                                    (double.parse(nicBaseEntry
                                            .percentageController.text) /
                                        100),
                              ) *
                          100)
                      .toStringAsFixed(0);

                  _nicBasePGController.text = (_nicBaseEntries
                              .where((nicBaseEntry) => !nicBaseEntry.isVG)
                              .fold(
                                0.0,
                                (sum, nicBaseEntry) =>
                                    sum +
                                    (double.parse(nicBaseEntry
                                            .percentageController.text) /
                                        100),
                              ) *
                          100)
                      .toStringAsFixed(0);
                });
                _updateValues();
              },
            ),
          ),
        ),
        const Gap(8),
        Container(
          constraints: const BoxConstraints(maxWidth: 120),
          child: ElTextField(
            labelText: withHeaders ? 'Percentage' : null,
            readOnly: !_isCustomChecked,
            value: ((entry.nicBase?.percentage ?? 0.0) * 100).toString(),
            contentType: ElTextFieldContentType.numeric,
            suffix: const Text("%"),
            onSubmitted: (value) {
              setState(() {
                _nicBaseVGController.text = (_nicBaseEntries
                            .where((nicBaseEntry) => nicBaseEntry.isVG)
                            .fold(
                              0.0,
                              (sum, nicBaseEntry) =>
                                  sum +
                                  (double.parse(nicBaseEntry
                                          .percentageController.text) /
                                      100),
                            ) *
                        100)
                    .toStringAsFixed(0);

                _nicBasePGController.text = (_nicBaseEntries
                            .where((nicBaseEntry) => !nicBaseEntry.isVG)
                            .fold(
                              0.0,
                              (sum, nicBaseEntry) =>
                                  sum +
                                  (double.parse(nicBaseEntry
                                          .percentageController.text) /
                                      100),
                            ) *
                        100)
                    .toStringAsFixed(0);
              });
              _updateValues();
            },
          ),
        ),
        const Gap(12.0),
        ElCheckbox(
          labelText: withHeaders ? 'VG' : null,
          value: entry.isVG,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var wrapperWidth = screenSize.width < 1920 ? 500.0 : null;
    var section2Width = screenSize.width < 1920 ? 500.0 : 400.0;

    final List<Recipe> recipes = widget.recipes;

    return Scaffold(
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
              Container(
                constraints: BoxConstraints(
                  maxWidth: wrapperWidth ?? double.infinity,
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20.0,
                  runSpacing: 8.0,
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 500,
                      ),
                      child: Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: _recipe == null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "RECIPE",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Gap(20.0),
                                        SearchAnchor(
                                          searchController: _searchController,
                                          viewShape:
                                              const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(4.0),
                                            ),
                                          ),
                                          viewSide: const BorderSide(
                                            color: Colors.white,
                                          ),
                                          builder: (context, controller) {
                                            return SearchBar(
                                              onTap: () {
                                                _searchController.openView();
                                              },
                                              leading: const Icon(Icons.search),
                                              elevation:
                                                  const WidgetStatePropertyAll(
                                                0.0,
                                              ),
                                              shape:
                                                  const WidgetStatePropertyAll(
                                                RoundedRectangleBorder(
                                                  side: BorderSide(),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(4.0),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          suggestionsBuilder:
                                              (context, controller) {
                                            final String input = controller
                                                .value.text
                                                .toLowerCase();
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
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    Text(
                                                      suggestionItem.name,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${suggestionItem.nicType.toString()} — ${suggestionItem.chilltype.toString()}",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    _searchController.closeView(
                                                      suggestionItem.name,
                                                    );
                                                    _recipe = suggestionItem;
                                                  });
                                                },
                                              );
                                            });
                                          },
                                        ),
                                      ],
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
                                              onPressed: () => _changeRecipe(),
                                            ),
                                          ],
                                        ),
                                        const Gap(25),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: ElDropdownMenu<NicProfile>(
                                                width: 360,
                                                labelText: 'Profile',
                                                initialSelection: _nicProfile,
                                                ignoring: false,
                                                dropdownMenuEntries:
                                                    UnmodifiableListView<
                                                        DropdownMenuEntry<
                                                            NicProfile>>(
                                                  _recipe!.nicProfiles.map<
                                                      DropdownMenuEntry<
                                                          NicProfile>>(
                                                    (nicProfile) =>
                                                        DropdownMenuEntry<
                                                            NicProfile>(
                                                      value: nicProfile,
                                                      label:
                                                          '${nicProfile.nicLevel} (${nicProfile.isNewMix ? 'New Mix' : 'Old Mix'})',
                                                    ),
                                                  ),
                                                ),
                                                onSelected:
                                                    (NicProfile? value) {
                                                  setState(() {
                                                    _nicProfile = value;
                                                  });

                                                  _onSelectNicProfile(
                                                    value?.nicLevel,
                                                  );

                                                  if (_volumeController.text ==
                                                      "") {
                                                    _volumeFocusNode
                                                        .requestFocus();
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 140,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsGeometry
                                                        .only(
                                                  left: 8.0,
                                                  right: 12.0,
                                                ),
                                                child: ElTextField(
                                                  readOnly:
                                                      _selectedNicProfValue ==
                                                          null,
                                                  labelText: "Nic Level",
                                                  value: _nicProfile != null
                                                      ? (_nicProfile!.isNewMix
                                                              ? double.parse(
                                                                      _targetNicStrController
                                                                          .text) *
                                                                  10
                                                              : double.parse(
                                                                      _targetNicStrController
                                                                          .text) *
                                                                  2.5)
                                                          .toString()
                                                      : "",
                                                  contentType:
                                                      ElTextFieldContentType
                                                          .numeric,
                                                  suffix: const Text("mg"),
                                                  onSubmitted:
                                                      _selectedNicProfValue !=
                                                              null
                                                          ? (value) {
                                                              if (value
                                                                  .isEmpty) {
                                                                return;
                                                              }
                                                              final bool
                                                                  isNewMix =
                                                                  _nicProfile!
                                                                      .isNewMix;

                                                              setState(() {
                                                                if (isNewMix) {
                                                                  _targetNicStrController
                                                                      .text = (double.parse(
                                                                              value) /
                                                                          10)
                                                                      .toStringAsFixed(
                                                                          2);
                                                                } else {
                                                                  _targetNicStrController
                                                                      .text = (double.parse(
                                                                              value) /
                                                                          2.5)
                                                                      .toStringAsFixed(
                                                                          2);
                                                                }
                                                              });
                                                              _updateValues();
                                                            }
                                                          : null,
                                                ),
                                              ),
                                            ),
                                            ElCheckbox(
                                              width: 50,
                                              value: _isCustomChecked,
                                              labelText: 'Custom',
                                              onChanged:
                                                  _selectedNicProfValue != null
                                                      ? (bool? newValue) {
                                                          setState(() {
                                                            _isCustomChecked =
                                                                newValue ??
                                                                    false;
                                                          });

                                                          if (newValue ==
                                                              false) {
                                                            _onSelectNicProfile(
                                                              _selectedNicProfValue,
                                                            );
                                                          }
                                                        }
                                                      : null,
                                            ),
                                          ],
                                        ),
                                        _selectedNicProfValue == null
                                            ? const SizedBox.shrink()
                                            : Column(
                                                children: [
                                                  const Gap(8.0),
                                                  ElTextField(
                                                    labelText: "Volume",
                                                    labelPosition:
                                                        ElTextFieldLabelPosition
                                                            .left,
                                                    contentType:
                                                        ElTextFieldContentType
                                                            .numeric,
                                                    value:
                                                        _volumeController.text,
                                                    suffix: const Text("mL"),
                                                    onSubmitted: (value) {
                                                      if (value.isEmpty) {
                                                        _volumeController.text =
                                                            _prevVolumeText;
                                                        return;
                                                      }
                                                      setState(() {
                                                        _volumeController.text =
                                                            value;
                                                      });
                                                      _updateValues();
                                                      _hasVolumeChanged =
                                                          value.isNotEmpty;
                                                    },
                                                  ),
                                                ],
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            _flavorings.length,
                                            (index) {
                                              final flavoring =
                                                  _flavorings[index];
                                              if (index == 0) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: ElTextField(
                                                        readOnly: true,
                                                        labelText: 'Name',
                                                        value: flavoring.name,
                                                        contentType:
                                                            ElTextFieldContentType
                                                                .text,
                                                      ),
                                                    ),
                                                    const Gap(8.0),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 140,
                                                          child: ElTextField(
                                                            labelText:
                                                                'Percentage',
                                                            readOnly:
                                                                !_isCustomChecked,
                                                            value: (flavoring
                                                                        .percentage *
                                                                    100)
                                                                .toStringAsFixed(
                                                                    4),
                                                            contentType:
                                                                ElTextFieldContentType
                                                                    .numeric,
                                                            suffix:
                                                                const Text("%"),
                                                          ),
                                                        ),
                                                        const Gap(12.0),
                                                        ElCheckbox(
                                                          labelText: 'VG',
                                                          value: flavoring.isVG,
                                                          onChanged: null,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: ElTextField(
                                                      readOnly: true,
                                                      value: flavoring.name,
                                                      contentType:
                                                          ElTextFieldContentType
                                                              .text,
                                                    ),
                                                  ),
                                                  const Gap(8.0),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 140,
                                                        child: ElTextField(
                                                          readOnly:
                                                              !_isCustomChecked,
                                                          value: (flavoring
                                                                      .percentage *
                                                                  100)
                                                              .toStringAsFixed(
                                                                  4),
                                                          contentType:
                                                              ElTextFieldContentType
                                                                  .numeric,
                                                          suffix:
                                                              const Text("%"),
                                                        ),
                                                      ),
                                                      const Gap(12.0),
                                                      ElCheckbox(
                                                        value: flavoring.isVG,
                                                        onChanged: null,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ],
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
                                "NIC BASE",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(20),
                              ElTextField(
                                labelText: 'Nic Str',
                                labelPosition: ElTextFieldLabelPosition.left,
                                value:
                                    ((_nicProfile?.nicBaseNicStr ?? 0.0) * 100)
                                        .toStringAsFixed(0),
                                contentType: ElTextFieldContentType.numeric,
                                readOnly: true,
                                suffix: const Text('%'),
                              ),
                              const Gap(8.0),
                              Row(
                                spacing: 8.0,
                                children: [
                                  Expanded(
                                    child: ElTextField(
                                      labelText: "VG",
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      value: _nicBaseVGController.text,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      readOnly: true,
                                      suffix: const Text('%'),
                                    ),
                                  ),
                                  Expanded(
                                    child: ElTextField(
                                      labelText: "PG",
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      value: _nicBasePGController.text,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      readOnly: true,
                                      suffix: const Text('%'),
                                    ),
                                  ),
                                ],
                              ),
                              _nicBaseEntries.isEmpty
                                  ? const SizedBox.shrink()
                                  : Column(
                                      children: [
                                        const Gap(16.0),
                                        const Divider(
                                          thickness: 1,
                                        ),
                                        const Gap(16.0),
                                        Column(
                                          spacing: 8.0,
                                          children: List.generate(
                                            _nicBaseEntries.length,
                                            (index) {
                                              final withHeaders =
                                                  index == 0 ? true : false;
                                              return _buildEntryRow(
                                                _nicBaseEntries[index],
                                                withHeaders,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                              _isCustomChecked
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () => _addEntry(null),
                                            child: const Text("+ Add"),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
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
                                labelText: "Nic Str",
                                labelPosition: ElTextFieldLabelPosition.left,
                                value: _targetNicStrController.text,
                                readOnly: true,
                                contentType: ElTextFieldContentType.numeric,
                                suffix: const Text('%'),
                                onSubmitted: (value) => _updateValues(),
                              ),
                              const Gap(8),
                              Row(
                                spacing: 8.0,
                                children: [
                                  Expanded(
                                    child: ElTextField(
                                      labelText: "VG",
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      value: _targetVGController.text,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      readOnly: !_isCustomChecked,
                                      suffix: const Text('%'),
                                      onSubmitted: (value) {
                                        setState(() {
                                          _targetVGController.text = value;
                                          _targetPGController.text =
                                              (100 - (double.parse(value)))
                                                  .toStringAsFixed(
                                                      _getDecimalPlaces(value));
                                        });
                                        _updateValues();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ElTextField(
                                      labelText: "PG",
                                      labelPosition:
                                          ElTextFieldLabelPosition.left,
                                      value: _targetPGController.text,
                                      contentType:
                                          ElTextFieldContentType.numeric,
                                      readOnly: !_isCustomChecked,
                                      suffix: const Text('%'),
                                      onSubmitted: (value) {
                                        setState(() {
                                          _targetPGController.text = value;
                                          _targetVGController.text =
                                              (100 - (double.parse(value)))
                                                  .toStringAsFixed(
                                                      _getDecimalPlaces(value));
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
                          borderRadius: BorderRadius.circular(
                            4.0,
                          ),
                        ),
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
