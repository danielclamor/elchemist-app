import 'package:elchemist_app/components/molecules/flavoring_entry_row.dart';
import 'package:elchemist_app/components/molecules/nic_base_entry_row.dart';
import 'package:elchemist_app/components/organisms/flavoring_section.dart';
import 'package:elchemist_app/components/organisms/formula_section.dart';
import 'package:elchemist_app/components/organisms/nic_base_section.dart';
import 'package:elchemist_app/components/organisms/target_section.dart';
import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/models/nic_base_option.dart';
import 'package:elchemist_app/models/nic_profile.dart';
import 'package:elchemist_app/models/formula.dart';
import 'package:elchemist_app/transitions.dart';
import 'package:elchemist_app/views/mix_view.dart';
import 'package:flutter/material.dart';

class RecipeDetailsView extends StatefulWidget {
  final Formula formula;
  final List<NicBaseOption> nicBaseOptions; // temporary

  const RecipeDetailsView({
    super.key,
    required this.formula,
    required this.nicBaseOptions,
  });

  @override
  State<RecipeDetailsView> createState() => _RecipeDetailsViewState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _RecipeDetailsViewState extends State<RecipeDetailsView> {
  late Formula _formula;
  NicProfile? _nicProfile;
  List<NicBase> nicBases = [];
  List<Flavoring> flavorings = [];

  final List<FlavoringEntry> _flavoringEntries = [];
  final List<NicBaseEntry> _nicBaseEntries = [];

  @override
  void initState() {
    _formula = widget.formula;

    super.initState();
  }

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
          name: flavoring.flavoringOption.name,
          ratio: flavoring.ratio,
          isVG: flavoring.flavoringOption.isVg,
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

  void _navigateToMix() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) =>
            Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text(
              "Formula",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 2.0,
          ),
          body: MixView(
            formula: _formula,
            initialNicProfile: _nicProfile,
            nicBaseOptions: widget.nicBaseOptions,
          ),
        ),
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) =>
            slideTransitionBuilder(
          context,
          animation,
          secondaryAnimation,
          child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const sectionWidth = 500.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Formula",
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
                    formula: _formula,
                    auxiliaryTool: IconButton(
                      onPressed: () => _navigateToMix(),
                      icon: const Icon(Icons.science),
                    ),
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
                            text: (_nicProfile!.nicBaseVg * 100).toString(),
                          ),
                          pgController: TextEditingController(
                            text: (_nicProfile!.nicBasePg * 100).toString(),
                          ),
                          nicBaseEntries: List.generate(
                            _nicBaseEntries.length,
                            (index) {
                              final entry = _nicBaseEntries[index];
                              return NicBaseEntryRow(
                                entry: entry,
                                withHeaders: index == 0,
                                showDeleteIcon: false,
                                nicBaseOptions: widget.nicBaseOptions,
                              );
                            },
                          ),
                        ),
                  _nicProfile == null
                      ? const SizedBox.shrink()
                      : TargetSection(
                          nicStrController: TextEditingController(
                            text: (_nicProfile!.targetNicStr * 100).toString(),
                          ),
                          vgController: TextEditingController(
                            text: (_nicProfile!.targetVg * 100).toString(),
                          ),
                          pgController: TextEditingController(
                            text: (_nicProfile!.targetPg * 100).toString(),
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
