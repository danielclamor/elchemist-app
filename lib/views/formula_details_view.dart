import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/components/molecules/flavoring_entry_row.dart';
import 'package:elchemist_app/components/molecules/nic_base_entry_row.dart';
import 'package:elchemist_app/components/organisms/flavoring_section.dart';
import 'package:elchemist_app/components/organisms/formula_section.dart';
import 'package:elchemist_app/components/organisms/nic_base_section.dart';
import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/models/nic_profile.dart';
import 'package:elchemist_app/models/formula.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RecipeDetailsView extends StatefulWidget {
  final Formula formula;

  const RecipeDetailsView({
    super.key,
    required this.formula,
  });

  @override
  State<RecipeDetailsView> createState() => _RecipeDetailsViewState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _RecipeDetailsViewState extends State<RecipeDetailsView> {
  NicProfile? _nicProfile;
  List<NicBase> nicBases = [];
  List<Flavoring> flavorings = [];

  final List<FlavoringEntry> _flavoringEntries = [];
  final List<NicBaseEntry> _nicBaseEntries = [];

  void _setNicProfile(NicProfile? nicProfile) {
    if (_nicProfile == nicProfile) return;

    setState(() {
      _nicProfile = nicProfile;
      if (_nicBaseEntries.isNotEmpty) {
        _nicBaseEntries.clear();
      }
      if (_flavoringEntries.isNotEmpty) {
        _flavoringEntries.clear();
      }
    });

    _populateFlavoringEntries();
    _populateNicBaseEntries();
  }

  void _populateFlavoringEntries() {
    if (_nicProfile == null) return;

    for (Flavoring flavoring in _nicProfile!.flavorings) {
      _addFlavoringEntry(
        FlavoringEntry(
          name: flavoring.name,
          ratio: flavoring.ratio,
          isVG: flavoring.isVG,
        ),
      );
    }
  }

  void _addFlavoringEntry(FlavoringEntry? entry) {
    setState(() {
      _flavoringEntries.add(entry ?? FlavoringEntry());
    });
  }

  void _populateNicBaseEntries() {
    if (_nicProfile == null) return;

    for (NicBase nicBase in _nicProfile!.nicBases) {
      _addNicBaseEntry(
        NicBaseEntry(
          nicBase: nicBase,
        ),
      );
    }
  }

  void _addNicBaseEntry(NicBaseEntry? entry) {
    setState(() {
      _nicBaseEntries.add(entry ?? NicBaseEntry());
    });
  }

  int _getDecimalPlaces(double value) {
    if (value == value.toInt()) return 0;
    List<String> parts = value.toString().split('.');

    return parts.length > 1 ? parts[1].length : 0;
  }

  @override
  Widget build(BuildContext context) {
    const sectionWidth = 500.0;
    const cardPadding = EdgeInsetsGeometry.all(24.0);

    final Formula formula = widget.formula;

    return Scaffold(
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
                  FormulaSection(
                    formula: formula,
                    nicProfile: _nicProfile,
                    nicLevelController: TextEditingController(
                      text: _nicProfile == null
                          ? ''
                          : (_nicProfile!.targetNicStr *
                                  (_nicProfile!.isNewMix ? 1000.0 : 250))
                              .toString(),
                    ),
                    onNicProfileSelected: (value) {
                      _setNicProfile(value);
                    },
                  ),
                  _nicProfile == null
                      ? const SizedBox.shrink()
                      : FlavoringSection(
                          flavoringEntries: List.generate(
                            _flavoringEntries.length,
                            (index) {
                              final entry = _flavoringEntries[index];
                              return FlavoringEntryRow(
                                entry: entry,
                                withHeaders: index == 0,
                                showDeleteIcon: false,
                              );
                            },
                          ),
                        ),
                  _nicProfile == null
                      ? const SizedBox.shrink()
                      : NicBaseSection(
                          nicStrController: TextEditingController(
                            text: (_nicProfile!.nicBaseNicStr * 100).toString(),
                          ),
                          vgController: TextEditingController(
                            text: (_nicProfile!.nicBaseVG * 100).toString(),
                          ),
                          pgController: TextEditingController(
                            text: (_nicProfile!.nicBasePG * 100).toString(),
                          ),
                          nicBaseEntries: List.generate(
                            _nicBaseEntries.length,
                            (index) {
                              final entry = _nicBaseEntries[index];
                              return NicBaseEntryRow(
                                entry: entry,
                                withHeaders: index == 0,
                                showDeleteIcon: false,
                              );
                            },
                          ),
                        ),
                  _nicProfile == null
                      ? const SizedBox.shrink()
                      : Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: cardPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'TARGET',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(20),
                                ElTextField(
                                  controller: TextEditingController(
                                    text: ((_nicProfile?.targetNicStr ?? 0.0) *
                                            100)
                                        .toStringAsFixed(2),
                                  ),
                                  contentType: ElTextFieldContentType.numeric,
                                  readOnly: true,
                                  labelText: "Nic Str",
                                  labelPosition: ElTextFieldLabelPosition.left,
                                  suffixText: '%',
                                ),
                                const Gap(8),
                                Row(
                                  spacing: 8.0,
                                  children: [
                                    Expanded(
                                      child: ElTextField(
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
                                        contentType:
                                            ElTextFieldContentType.numeric,
                                        readOnly: true,
                                        labelText: 'VG',
                                        labelPosition:
                                            ElTextFieldLabelPosition.left,
                                        suffixText: '%',
                                      ),
                                    ),
                                    Expanded(
                                      child: ElTextField(
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
                                        contentType:
                                            ElTextFieldContentType.numeric,
                                        readOnly: true,
                                        labelText: 'PG',
                                        labelPosition:
                                            ElTextFieldLabelPosition.left,
                                        suffixText: '%',
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
