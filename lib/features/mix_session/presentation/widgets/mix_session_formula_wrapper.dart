// import 'package:elchemist_app/features/flavor/presentation/widgets/pre_mix_chip.dart';
// import 'package:elchemist_app/features/formula/presentation/widgets/flavoring_entry_row.dart';
// import 'package:elchemist_app/features/flavoring_option.dart/domain/flavoring_option.dart';
// import 'package:elchemist_app/features/formula/presentation/widgets/nic_base_entry_row.dart';
// import 'package:elchemist_app/features/mix_batch/presentation/widgets/mix_batch_volume_section.dart';
// import 'package:elchemist_app/features/formula/presentation/widgets/flavoring_section.dart';
// import 'package:elchemist_app/features/formula/presentation/widgets/nic_base_section.dart';
// import 'package:elchemist_app/features/mix_batch/presentation/widgets/mix_batch_recipe_section.dart';
// import 'package:elchemist_app/components/organisms/target_section.dart';
// import 'package:elchemist_app/features/formula/providers/formula_providers.dart';
// import 'package:elchemist_app/features/nic_base_option/domain/nic_base_option.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gap/gap.dart';

// class MixSessionFormulaWrapper extends ConsumerStatefulWidget {
//   final String formulaId;

//   const MixSessionFormulaWrapper({
//     super.key,
//     required this.formulaId,
//   });

//   @override
//   ConsumerState<MixSessionFormulaWrapper> createState() =>
//       _MixSessionFormulaWrapperState();
// }

// class _MixSessionFormulaWrapperState
//     extends ConsumerState<MixSessionFormulaWrapper> {
//   final _nicBaseEntries = <String, NicBaseEntry>{};

//   NicBaseEntry _nicBaseEntry(NicBaseOption o, double? ratio) => _nicBaseEntries
//       .putIfAbsent(o.id, () => NicBaseEntry(nicBaseOption: o, ratio: ratio));

//   // void _disposeNicBaseEntry(String id) {
//   //   final entry = _nicBaseEntries.remove(id);
//   //   WidgetsBinding.instance.addPostFrameCallback((_) => entry?.dispose());
//   // }

//   // void _removeNicBase(NicBaseOption o) {
//   //   // setState(() => _selectedNicBaseOptions.remove(o));
//   //   _disposeNicBaseEntry(o.id);
//   // }

//   // double _totalNicBaseVGRatio() => _nicBaseEntries.values
//   //     .where((entry) => entry.nicBaseOption.isVg)
//   //     .fold(0, (sum, e) => sum + e.ratio);

//   // double _totalNicBasePGRatio() => _nicBaseEntries.values
//   //     .where((entry) => !entry.nicBaseOption.isVg)
//   //     .fold(0, (sum, e) => sum + e.ratio);

//   final _flavoringEntries = <String, FlavoringEntry>{};

//   FlavoringEntry _flavoringEntry(FlavoringOption o, double? ratio) =>
//       _flavoringEntries.putIfAbsent(
//           o.id, () => FlavoringEntry(flavoringOption: o, ratio: ratio));

//   bool _isCustom = false;

//   // late TextEditingController _nicLevelController;
//   late TextEditingController _volumeController;
//   // late TextEditingController _nicBaseNicStrController;
//   // late TextEditingController _nicBaseVGController;
//   // late TextEditingController _nicBasePGController;
//   // late TextEditingController _targetNicStrController;
//   // late TextEditingController _targetVGController;
//   // late TextEditingController _targetPGController;

//   List<TextEditingController> get _allControllers => [
//         // _nicLevelController,
//         _volumeController,
//         // _nicBaseNicStrController,
//         // _nicBaseVGController,
//         // _nicBasePGController,
//         // _targetNicStrController,
//         // _targetVGController,
//         // _targetPGController,
//       ];

//   @override
//   void initState() {
//     _volumeController = TextEditingController(text: "0");
//     // _nicLevelController = TextEditingController(text: "0");

//     // _targetNicStrController = TextEditingController(text: "0");
//     // _targetVGController = TextEditingController(text: "0");
//     // _targetPGController = TextEditingController(text: "0");

//     // _nicBaseNicStrController = TextEditingController(text: "0");
//     // _nicBaseVGController = TextEditingController(text: "0");
//     // _nicBasePGController = TextEditingController(text: "0");

//     // _setFormula(widget.formula);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     for (final c in _allControllers) {
//       c.dispose();
//     }
//   }

//   // void _setFormula(Formula? formula) {
//   //   if (_formula == formula) return;

//   //   setState(() {
//   //     _formula = formula;

//   //     if (_formula == null) {
//   //       _volumeController = TextEditingController(text: "0");
//   //       _nicLevelController = TextEditingController(text: "0");

//   //       _targetNicStrController = TextEditingController(text: "0");
//   //       _targetVGController = TextEditingController(text: "0");
//   //       _targetPGController = TextEditingController(text: "0");

//   //       _nicBaseNicStrController = TextEditingController(text: "0");
//   //       _nicBaseVGController = TextEditingController(text: "0");
//   //       _nicBasePGController = TextEditingController(text: "0");
//   //     } else {
//   //       _nicLevelController.text =
//   //           (_formula!.targetNicStr * _formula!.nicLevelMultiplier).toString();
//   //       _nicBaseNicStrController.text =
//   //           (_formula!.nicBaseNicStr * 100.0).toString();
//   //       _targetNicStrController.text =
//   //           (_formula!.targetNicStr * 100.0).toString();
//   //       _targetVGController.text = (_formula!.targetVg * 100.0).toString();
//   //       _targetPGController.text = (_formula!.targetPg * 100.0).toString();
//   //     }

//   //     if (_nicBaseEntries.isNotEmpty) {
//   //       _nicBaseEntries.clear();
//   //     }

//   //     if (_flavoringEntries.isNotEmpty) {
//   //       _flavoringEntries.clear();
//   //     }
//   //   });

//   //   _populateFlavoringEntries();
//   //   _populateNicBaseEntries();
//   // }

//   // void _populateFlavoringEntries() {
//   //   if (_formula == null) return;

//   //   for (Flavoring flavoring in _formula!.flavorings) {
//   //     _addFlavoringEntry(
//   //       FlavoringEntry(
//   //         name: flavoring.flavoringOption.name,
//   //         ratio: flavoring.ratio,
//   //         isVG: flavoring.flavoringOption.isVg,
//   //       ),
//   //     );
//   //   }
//   // }

//   // void _addFlavoringEntry(FlavoringEntry? entry) {
//   //   setState(() {
//   //     _flavoringEntries.add(entry ?? FlavoringEntry());
//   //   });
//   // }

//   // void _populateNicBaseEntries() {
//   //   if (_formula == null) return;

//   //   for (NicBase nicBase in _formula!.nicBases) {
//   //     _addNicBaseEntry(
//   //       NicBaseEntry(
//   //         nicBaseOption: nicBase,
//   //       ),
//   //     );
//   //   }

//   //   _calculateTotalNicBaseRatio();
//   // }

//   // void _calculateTotalNicBaseRatio() {
//   //   double totalNicBaseVGPerc = (_nicBaseEntries
//   //           .where((entry) => entry.isVG)
//   //           .fold(0.0, (sum, entry) => sum + entry.ratio)) *
//   //       100;

//   //   double totalNicBasePGPerc = (_nicBaseEntries
//   //           .where((entry) => !entry.isVG)
//   //           .fold(0.0, (sum, entry) => sum + entry.ratio)) *
//   //       100;

//   //   setState(() {
//   //     _nicBaseVGController.text = totalNicBaseVGPerc.toString();
//   //     _nicBasePGController.text = totalNicBasePGPerc.toString();
//   //   });
//   // }

//   // void _addNicBaseEntry(NicBaseEntry? entry) {
//   //   setState(() {
//   //     _nicBaseEntries.add(entry ?? NicBaseEntry());
//   //   });
//   // }

//   // void _removeNicBaseEntry(NicBaseEntry entry) {
//   //   setState(() {
//   //     entry.dispose();
//   //     _nicBaseEntries.remove(entry);
//   //   });
//   //   _calculateTotalNicBaseRatio();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     var wrapperWidth = screenSize.width < 1920 ? 800.0 : null;
//     var sectionWidth = 350.0;
//     var recipeSectionWidth =
//         screenSize.width < 1920 ? sectionWidth : sectionWidth + 250;

//     final async = ref.watch(formulaDetailsProvider(widget.formulaId));

//     return async.when(
//       error: (error, stackTrace) => SizedBox.shrink(),
//       loading: () => SizedBox.shrink(),
//       data: (data) {
//         if (data == null) return SizedBox.shrink();

//         final formula = data;
//         final nicBases = formula.nicBases;
//         final flavorings = formula.flavorings;

//         final nicLevel = formula.targetNicStr * formula.nicLevelMultiplier;

//         final targetNicStrController =
//             TextEditingController(text: '${formula.targetNicStr * 100}');
//         final targetVGController =
//             TextEditingController(text: '${formula.targetVg * 100}');
//         final targetPGController =
//             TextEditingController(text: '${formula.targetPg * 100}');

//         final nicBaseNicStrController =
//             TextEditingController(text: '${formula.nicBaseNicStr * 100}');
//         final nicBaseVGController =
//             TextEditingController(text: '${formula.nicBaseVg * 100}');
//         final nicBasePGController =
//             TextEditingController(text: '${formula.nicBasePg * 100}');

//         return Center(
//           child: Container(
//             constraints: BoxConstraints(
//               maxWidth: wrapperWidth ?? double.infinity,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       formula.fullName,
//                       style: TextStyle(
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     if (formula.isPreMix)
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: PreMixChip(
//                           fgColor: Colors.black,
//                           bgColor: Colors.grey,
//                         ),
//                       ),
//                   ],
//                 ),
//                 Text(
//                   'Nic Level: ${nicLevel.toInt()}mg',
//                   style: TextStyle(
//                     fontSize: 16,
//                   ),
//                 ),
//                 const Gap(24),
//                 Wrap(
//                   alignment: WrapAlignment.center,
//                   spacing: 20.0,
//                   runSpacing: 8.0,
//                   children: [
//                     Container(
//                       constraints: BoxConstraints(
//                         maxWidth: recipeSectionWidth,
//                       ),
//                       child: Column(
//                         spacing: 20.0,
//                         children: [
//                           MixSessionVolumeSection(),
//                           MixSessionRecipeSection(
//                             formulaId: formula.id,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       constraints: BoxConstraints(
//                         maxWidth: sectionWidth,
//                       ),
//                       child: Column(
//                         spacing: 20.0,
//                         children: [
//                           MixSessionFlavoringSection(
//                             flavoringEntries: List.generate(
//                               flavorings.length,
//                               (index) {
//                                 final flavoring = flavorings[index];
//                                 final entry = _flavoringEntry(
//                                   flavoring.flavoringOption,
//                                   flavoring.ratio,
//                                 );
//                                 return FlavoringEntryRow(
//                                   entry: entry,
//                                   isCustom: _isCustom,
//                                   onPercentSubmitted: _isCustom
//                                       ? (value) => setState(() {})
//                                       : null,
//                                 );
//                               },
//                             ),
//                           ),
//                           MixSessionTargetSection(
//                             nicStrController: targetNicStrController,
//                             vgController: targetVGController,
//                             onVGSubmitted: !_isCustom
//                                 ? null
//                                 : (value) {
//                                     setState(() {
//                                       targetVGController.text = value;
//                                       targetPGController.text =
//                                           (100 - (double.parse(value)))
//                                               .toString();
//                                     });
//                                   },
//                             pgController: targetPGController,
//                             onPGSubmitted: !_isCustom
//                                 ? null
//                                 : (value) {
//                                     setState(() {
//                                       targetPGController.text = value;
//                                       targetVGController.text =
//                                           (100 - (double.parse(value)))
//                                               .toString();
//                                     });
//                                   },
//                           ),
//                           MixNicBaseSection(
//                             nicStrController: nicBaseNicStrController,
//                             vgController: nicBaseVGController,
//                             pgController: nicBasePGController,
//                             nicBaseEntries: List.generate(
//                               nicBases.length,
//                               (index) {
//                                 final nicBase = nicBases[index];
//                                 final entry = _nicBaseEntry(
//                                   nicBase.nicBaseOption,
//                                   nicBase.ratio,
//                                 );
//                                 return NicBaseEntryRow(
//                                   entry: entry,
//                                   isCustom: _isCustom,
//                                   onPercentSubmitted: _isCustom
//                                       ? (value) => setState(() {})
//                                       : null,
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
