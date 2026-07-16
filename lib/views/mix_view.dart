import 'package:collection/collection.dart';
import 'package:elchemist_app/formulas.dart';
import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/ingredient.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/models/nic_profile.dart';
import 'package:elchemist_app/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
  Recipe? recipe;
  String? _selectedNicProfValue;
  NicProfile? _nicProfile;
  bool _isCustomChecked = false;

  late SearchController _searchController;
  late TextEditingController _volumeController;
  late TextEditingController _nicStrController;
  late TextEditingController _targetVGController;
  late TextEditingController _targetPGController;
  List<NicBase>? nicBases;
  List<Flavoring>? flavorings;

  final FocusNode _volumeFocusNode = FocusNode();
  String _prevVolumeText = "";
  bool _hasVolumeChanged = false;

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
  void initState() {
    _searchController = SearchController();
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

  (double, double, double) _getNicBaseValues() {
    final double volume = _volumeController.text == ""
        ? 0.0
        : double.parse(_volumeController.text);

    var nicotineVol = 0.0;
    var nicBaseVGVol = 0.0;
    var nicBasePGVol = 0.0;

    if (nicBases != null && nicBases!.isNotEmpty) {
      nicBaseVGVol = nicBases!.where((nicBase) => nicBase.isVg).fold(
            0.0,
            (sum, nicBase) =>
                sum +
                nicBaseCompVol(
                  volume,
                  _nicProfile!.targetNicStr,
                  _nicProfile!.nicBaseStr,
                  nicBase.percentage,
                ),
          );

      nicBasePGVol = nicBases!.where((nicBase) => !nicBase.isVg).fold(
            0.0,
            (sum, nicBase) =>
                sum +
                nicBaseCompVol(
                  volume,
                  _nicProfile!.targetNicStr,
                  _nicProfile!.nicBaseStr,
                  nicBase.percentage,
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

    double totalFlavVGPerc = flavorings
            ?.where((flavor) => flavor.isVG)
            .fold(0.0, (sum, flavor) => sum! + flavor.percentage) ??
        0.0;

    double totalNicBaseVGPerc = nicBases
            ?.where((nicBase) => nicBase.isVg)
            .fold(0.0, (sum, nicBase) => sum! + nicBase.percentage) ??
        0.0;

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

    // double flavPGVol = (flavorings
    //             ?.where((flavor) => !flavor.isVG)
    //             .fold(0.0, (sum, flavor) => sum + flavor.percentage) ??
    //         0.0) *
    //     volume;

    // double targetPGVol = targetCompVol(
    //   volume,
    //   _nicProfile != null ? _nicProfile!.targetNicStr : 0.0,
    //   _nicProfile != null ? _nicProfile!.targetVG : 0.0,
    // );

    // double nicBasePGVol = nicBases?.where((nicBase) => !nicBase.isVg).fold(
    //           0.0,
    //           (sum, nicBase) =>
    //               sum! +
    //               nicBaseCompVol(
    //                 volume,
    //                 _nicProfile!.targetNicStr,
    //                 _nicProfile!.nicBaseStr,
    //                 nicBase.percentage,
    //               ),
    //         ) ??
    //     0.0;

    double totalFlavPGPerc = flavorings
            ?.where((flavor) => !flavor.isVG)
            .fold(0.0, (sum, flavor) => sum! + flavor.percentage) ??
        0.0;

    double totalNicBasePGPerc = nicBases
            ?.where((nicBase) => !nicBase.isVg)
            .fold(0.0, (sum, nicBase) => sum! + nicBase.percentage) ??
        0.0;

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
    ingredients = <Ingredient>[];

    if (nicBases != null && nicBases!.isNotEmpty) {
      var nicBaseTitle =
          'Nicotine base ${nicBases?.map((nicBase) => '(${nicBase.code})').join(" / ")}';

      var (nicBasePercentage, nicBaseVolume, nicBaseweight) =
          _getNicBaseValues();

      ingredients.add(
        Ingredient(
          name: nicBaseTitle,
          percentage: nicBasePercentage,
          volume: nicBaseVolume,
          weight: nicBaseweight,
          type: IngredientType.nicotine,
        ),
      );
    }

    if (flavorings != null && flavorings!.isNotEmpty) {
      flavorings?.forEach(
        (flavoring) {
          var (flavoringPerc, flavoringVol, flavoringWeight) = _getFlavorValues(
            flavoring.isVG,
            flavoring.percentage,
          );

          ingredients.add(
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
        },
      );
    }

    final ingredientVG = ingredients.firstWhereOrNull(
      (ingredient) => ingredient.name == "VG",
    );
    var (ingredientVGPerc, ingredientVGVol, ingredientVGWeight) =
        _getVGValues();

    if (ingredientVG != null) {
      ingredientVG.percentage = ingredientVGPerc;
      ingredientVG.volume = ingredientVGVol;
      ingredientVG.weight = ingredientVGWeight;
    } else {
      ingredients.add(
        Ingredient(
          name: "VG",
          percentage: ingredientVGPerc,
          volume: ingredientVGVol,
          weight: ingredientVGWeight,
          type: IngredientType.vg,
        ),
      );
    }

    final ingredientPG = ingredients.firstWhereOrNull(
      (ingredient) => ingredient.name == "PG",
    );
    var (ingredientPGPerc, ingredientPGVol, ingredientPGWeight) =
        _getPGValues();

    if (ingredientPG != null) {
      ingredientPG.percentage = ingredientPGPerc;
      ingredientPG.volume = ingredientPGVol;
      ingredientPG.weight = ingredientPGWeight;
    } else {
      ingredients.add(
        Ingredient(
          name: "PG",
          percentage: ingredientPGPerc,
          volume: ingredientPGVol,
          weight: ingredientPGWeight,
          type: IngredientType.pg,
        ),
      );
    }

    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    final List<Recipe> recipes = widget.recipes;

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
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  constraints:
                      const BoxConstraints(minWidth: 500, maxWidth: 500),
                  child: recipe == null
                      ? SearchAnchor(
                          searchController: _searchController,
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
                              elevation: const WidgetStatePropertyAll(0.0),
                              shape: const WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                ),
                              ),
                              backgroundColor:
                                  const WidgetStatePropertyAll(Colors.white),
                            );
                          },
                          suggestionsBuilder: (context, controller) {
                            final String input =
                                controller.value.text.toLowerCase();
                            final Iterable<Recipe> filteredSuggestions =
                                recipes.where((recipeItem) {
                              return recipeItem.name
                                  .toLowerCase()
                                  .contains(input);
                            });

                            return filteredSuggestions.map((suggestionItem) {
                              return ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      suggestionItem.brand.toUpperCase(),
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
                                    controller.closeView(suggestionItem.name);
                                    recipe = suggestionItem;
                                  });
                                },
                              );
                            });
                          },
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      recipe!.brand.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      recipe!.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${recipe!.nicType.toString()} — ${recipe!.chilltype.toString()}',
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
                                      recipe = null;
                                      _selectedNicProfValue = null;
                                      _nicProfile = null;
                                      _searchController.clear();
                                      _volumeController.clear();
                                      _nicStrController.clear();
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
                                  initialSelection: _selectedNicProfValue,
                                  inputDecorationTheme:
                                      const InputDecorationTheme(
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
                                    recipe!.nicProfiles.map<MenuEntry>(
                                      (nicProfile) => MenuEntry(
                                        value: nicProfile.name,
                                        label:
                                            '${nicProfile.name} (${nicProfile.isNewMix ? 'New Mix' : 'Old Mix'})',
                                      ),
                                    ),
                                  ),
                                  onSelected: (String? value) {
                                    _nicProfile = recipe!.nicProfiles
                                        .firstWhere((nicProfile) =>
                                            nicProfile.name == value);
                                    var nicStr =
                                        _nicProfile!.targetNicStr * 100;
                                    var targetVG = _nicProfile!.targetVG * 100;
                                    var targetPG = _nicProfile!.targetPG * 100;

                                    setState(() {
                                      _selectedNicProfValue = value;
                                      _nicStrController.text =
                                          nicStr.toString();
                                      _targetVGController.text =
                                          targetVG.toStringAsFixed(4);
                                      _targetPGController.text =
                                          targetPG.toStringAsFixed(4);

                                      nicBases = _nicProfile!.nicBaseList;
                                      flavorings = _nicProfile!.flavoringList;

                                      ingredients = _populateIngredients();
                                    });

                                    if (_volumeController.text == "") {
                                      _volumeFocusNode.requestFocus();
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
                            _selectedNicProfValue == null
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
                                      if (value.isEmpty) {
                                        _volumeController.text =
                                            _prevVolumeText;
                                        return;
                                      }

                                      setState(() {
                                        _volumeController.text = value;
                                        ingredients = _populateIngredients();
                                      });
                                      _hasVolumeChanged = value.isNotEmpty;
                                    },
                                  ),
                            _selectedNicProfValue == null
                                ? const SizedBox.shrink()
                                : Column(
                                    spacing: 12,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              readOnly: !_isCustomChecked,
                                              controller: _targetVGController,
                                              keyboardType:
                                                  TextInputType.number,
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
                                              readOnly: !_isCustomChecked,
                                              controller: _targetPGController,
                                              keyboardType:
                                                  TextInputType.number,
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
                            _selectedNicProfValue == null || nicBases!.isEmpty
                                ? const SizedBox.shrink()
                                : Column(
                                    spacing: 12,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            'Nic Str: ${(_nicProfile!.nicBaseStr * 100).toStringAsFixed(2)}%',
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
                                                readOnly: !_isCustomChecked,
                                                controller:
                                                    TextEditingController(
                                                  text:
                                                      (nicBase.percentage * 100)
                                                          .toStringAsFixed(0),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
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
                                                      const EdgeInsets
                                                          .symmetric(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                controller:
                                                    TextEditingController(
                                                  text: flavoring.name,
                                                ),
                                                decoration:
                                                    const InputDecoration(
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
                                                          maxWidth: 120),
                                                  child: TextField(
                                                    readOnly: true,
                                                    controller:
                                                        TextEditingController(
                                                      text: (flavoring
                                                                  .percentage *
                                                              100)
                                                          .toStringAsFixed(4),
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
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    4.0,
                  ),
                ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
