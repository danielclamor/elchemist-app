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
  List<NicBase> nicBases = [];
  List<Flavoring> flavorings = [];

  int _getDecimalPlaces(double value) {
    if (value == value.toInt()) return 0;
    List<String> parts = value.toString().split('.');

    return parts.length > 1 ? parts[1].length : 0;
  }

  @override
  Widget build(BuildContext context) {
    const sectionWidth = 500.0;
    const cardPadding = EdgeInsetsGeometry.all(24.0);

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
        child: Center(
          child: Padding(
            padding: const EdgeInsetsGeometry.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: sectionWidth),
              child: Column(
                spacing: 8.0,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        4.0,
                      ),
                    ),
                    color: Colors.white,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: cardPadding,
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
                                  recipe.nicProfiles.map<MenuEntry>(
                                    (nicProfile) => MenuEntry(
                                      value: nicProfile.nicLevel,
                                      label:
                                          '${nicProfile.nicLevel} (${nicProfile.isNewMix ? 'New Mix' : 'Old Mix'})',
                                    ),
                                  ),
                                ),
                                onSelected: (String? value) {
                                  _nicProfile = recipe.nicProfiles.firstWhere(
                                      (nicProfile) =>
                                          nicProfile.nicLevel == value);

                                  setState(() {
                                    _selectedNicProfValue = value;

                                    nicBases = _nicProfile!.nicBases;
                                    flavorings = _nicProfile!.flavorings;
                                  });
                                },
                              ),
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: ((_nicProfile?.targetNicStr ?? 0.0) *
                                            100)
                                        .toStringAsFixed(2),
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
                                    labelText: "Nic Strength",
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
                    ),
                  ),
                  _selectedNicProfValue == null
                      ? const SizedBox.shrink()
                      : Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          color: Colors.white,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: cardPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Flavouring",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(12),
                                ...flavorings.map(
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
                          ),
                        ),
                  _selectedNicProfValue == null
                      ? const SizedBox.shrink()
                      : Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          color: Colors.white,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: cardPadding,
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
                                    text: ((_nicProfile?.nicBaseNicStr ?? 0.0) *
                                            100)
                                        .toStringAsFixed(0),
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
                                          text: (nicBases
                                                      .where((nicBase) =>
                                                          nicBase.isVG)
                                                      .fold(
                                                          0.0,
                                                          (sum, nicBase) =>
                                                              sum +
                                                              nicBase
                                                                  .percentage) *
                                                  100)
                                              .toStringAsFixed(0),
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
                                        controller: TextEditingController(
                                          text: (nicBases
                                                      .where((nicBase) =>
                                                          !nicBase.isVG)
                                                      .fold(
                                                          0.0,
                                                          (sum, nicBase) =>
                                                              sum +
                                                              nicBase
                                                                  .percentage) *
                                                  100)
                                              .toStringAsFixed(0),
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
                                nicBases.isEmpty
                                    ? const SizedBox.shrink()
                                    : Column(
                                        children: [
                                          const Gap(8.0),
                                          Divider(
                                            thickness: 1,
                                            color: Colors.grey[350],
                                          ),
                                          const Gap(8.0),
                                          ...nicBases.map(
                                            (nicBase) => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    readOnly: true,
                                                    controller:
                                                        TextEditingController(
                                                      text: nicBase.label,
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
                                                const Gap(8),
                                                Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 120),
                                                  child: TextField(
                                                    readOnly: true,
                                                    controller:
                                                        TextEditingController(
                                                      text: (nicBase
                                                                  .percentage *
                                                              100)
                                                          .toStringAsFixed(0),
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
                                                      value: nicBase.isVG,
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
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                  _selectedNicProfValue == null
                      ? const SizedBox.shrink()
                      : Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          color: Colors.white,
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: cardPadding,
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
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: ((_nicProfile?.targetNicStr ?? 0.0) *
                                            100)
                                        .toStringAsFixed(2),
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
                                          text: ((_nicProfile?.targetVG ??
                                                      0.0) *
                                                  100)
                                              .toStringAsFixed(_getDecimalPlaces(
                                                              _nicProfile
                                                                      ?.targetVG ??
                                                                  0.0) -
                                                          2 >
                                                      4
                                                  ? _getDecimalPlaces(
                                                          _nicProfile
                                                                  ?.targetVG ??
                                                              0.0) -
                                                      2
                                                  : 4),
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
                                        controller: TextEditingController(
                                          text: ((_nicProfile?.targetPG ??
                                                      0.0) *
                                                  100)
                                              .toStringAsFixed(_getDecimalPlaces(
                                                              _nicProfile
                                                                      ?.targetPG ??
                                                                  0.0) -
                                                          2 >
                                                      4
                                                  ? _getDecimalPlaces(
                                                          _nicProfile
                                                                  ?.targetPG ??
                                                              0.0) -
                                                      2
                                                  : 4),
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
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
