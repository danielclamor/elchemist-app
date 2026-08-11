import 'package:elchemist_app/components/molecules/flavoring_entry_row.dart';
import 'package:elchemist_app/components/molecules/nic_base_entry_row.dart';
import 'package:elchemist_app/constants.dart';
import 'package:elchemist_app/models/ingredient.dart';

class MixRecipeCalculator {
  final double batchVolume;
  final double nicBaseNicStr;
  final double nicBaseVG;
  final double nicBasePG;
  final List<NicBaseEntry> nicBaseEntries;
  final double targetNicStr;
  final double targetVG;
  final double targetPG;
  final List<FlavoringEntry> flavoringEntries;

  double totalNicBaseVGRatio;
  double totalNicBasePGRatio;
  double totalFlavVGRatio;
  double totalFlavPGRatio;

  MixRecipeCalculator({
    required this.batchVolume,
    required this.nicBaseNicStr,
    this.nicBaseVG = 0.0,
    this.nicBasePG = 0.0,
    List<NicBaseEntry>? nicBaseEntries,
    required this.targetNicStr,
    required this.targetVG,
    required this.targetPG,
    required this.flavoringEntries,
  })  : nicBaseEntries = nicBaseEntries ?? [],
        totalNicBaseVGRatio = 0.0,
        totalNicBasePGRatio = 0.0,
        totalFlavVGRatio = 0.0,
        totalFlavPGRatio = 0.0;

  double get _totalNicBaseRatio => targetNicStr / nicBaseNicStr;

  double _getRatio(
    double totalNicBaseMixRatio,
    double totalFlavMixRatio,
    bool isVG,
  ) {
    final baseComponent = isVG ? targetVG : targetPG;

    return baseComponent -
        totalFlavMixRatio +
        (targetNicStr *
            (totalNicBaseMixRatio -
                baseComponent -
                (totalNicBaseMixRatio / nicBaseNicStr)));
  }

  Ingredient _getVG({
    required double totalNicBaseMixRatio,
    required double totalFlavMixRatio,
  }) {
    final ratio = _getRatio(totalNicBaseMixRatio, totalFlavMixRatio, true);
    final volume = ratio * batchVolume;
    final weight = volume * vgDensity;

    return Ingredient(
      name: 'VG',
      ratio: ratio,
      volume: volume.isNaN ? 0.0 : volume,
      weight: weight.isNaN ? 0.0 : weight,
    );
  }

  Ingredient _getPG({
    required double totalNicBaseMixRatio,
    required double totalFlavMixRatio,
  }) {
    final ratio = _getRatio(totalNicBaseMixRatio, totalFlavMixRatio, false);
    final volume = ratio * batchVolume;
    final weight = volume * pgDensity;

    return Ingredient(
      name: 'PG',
      ratio: ratio,
      volume: volume.isNaN ? 0.0 : volume,
      weight: weight.isNaN ? 0.0 : weight,
    );
  }

  Ingredient? _getNicBase(double ratio, bool isVG, String? code) {
    if (ratio <= 0.0) return null;

    final nicBaseRatio = ratio;
    final nicBaseMixRatio = _totalNicBaseRatio * nicBaseRatio;
    final nicBaseNicMixRatio = targetNicStr * nicBaseRatio;
    final nicBaseBaseVolume =
        batchVolume * (nicBaseMixRatio - nicBaseNicMixRatio);
    final nicBaseNicVolume = batchVolume * nicBaseNicMixRatio;
    final nicBaseNicWeight = nicBaseNicVolume * nicDensity;

    double nicBaseWeight;

    if (isVG) {
      totalNicBaseVGRatio += nicBaseRatio;
      nicBaseWeight = nicBaseNicWeight + (nicBaseBaseVolume * vgDensity);
    } else {
      totalNicBasePGRatio += nicBaseRatio;
      nicBaseWeight = nicBaseNicWeight + (nicBaseBaseVolume * pgDensity);
    }

    return Ingredient(
      name: 'Nicotine Base (${code ?? (isVG ? 'VG' : 'PG')})',
      ratio: nicBaseMixRatio * 100,
      volume: nicBaseBaseVolume + nicBaseNicVolume,
      weight: nicBaseWeight,
    );
  }

  List<Ingredient> get _allNicBases {
    if (targetNicStr <= 0.0) return [];

    if (nicBaseEntries.isNotEmpty) {
      return nicBaseEntries
          .map((entry) {
            return _getNicBase(entry.ratio, entry.isVG, entry.code);
          })
          .whereType<Ingredient>()
          .toList();
    }

    return [
      _getNicBase(nicBaseVG, true, "VG"),
      _getNicBase(nicBasePG, false, "PG"),
    ].whereType<Ingredient>().toList();
  }

  List<Ingredient> get _allFlavorings {
    return flavoringEntries.map((flavor) {
      final volume = flavor.ratio * batchVolume;
      double weight;

      if (flavor.isVG) {
        totalFlavVGRatio += flavor.ratio;
        weight = volume * vgFlavDensity;
      } else {
        totalFlavPGRatio += flavor.ratio;
        weight = volume * pgFlavDensity;
      }

      return Ingredient(
        name:
            '${flavor.name == '' ? 'Flavour' : flavor.name} (${flavor.isVG ? 'VG' : 'PG'})',
        ratio: flavor.ratio,
        volume: volume,
        weight: weight,
      );
    }).toList();
  }

  List<Ingredient> get ingredients {
    return [
      ..._allNicBases,
      ..._allFlavorings,
      _getVG(
        totalNicBaseMixRatio: nicBaseVG,
        totalFlavMixRatio: totalFlavVGRatio,
      ),
      _getPG(
        totalNicBaseMixRatio: nicBasePG,
        totalFlavMixRatio: totalFlavPGRatio,
      ),
    ];
  }
}
