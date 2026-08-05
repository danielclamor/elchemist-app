import 'package:elchemist_app/components/organisms/nic_base_section.dart';
import 'package:elchemist_app/constants.dart';
import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/ingredient.dart';

class MixRecipeCalculator {
  final double batchVolume;
  final double nicBaseNicStr;
  final double targetNicStr;
  final double targetVG;
  final double targetPG;
  final List<NicBaseEntry> nicBaseEntries;
  final List<Flavoring> flavorings;

  const MixRecipeCalculator({
    required this.batchVolume,
    required this.nicBaseNicStr,
    required this.targetNicStr,
    required this.targetVG,
    required this.targetPG,
    required this.nicBaseEntries,
    required this.flavorings,
  });

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
      percentage: ratio,
      volume: volume.isNaN ? 0.0 : volume,
      weight: weight.isNaN ? 0.0 : weight,
      type: IngredientType.vg,
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
      percentage: ratio,
      volume: volume.isNaN ? 0.0 : volume,
      weight: weight.isNaN ? 0.0 : weight,
      type: IngredientType.pg,
    );
  }

  /// The finalized list of ingredients: nic bases, flavorings, then VG/PG fill.
  List<Ingredient> get ingredients {
    double totalNicBaseVGRatio = 0.0;
    double totalNicBasePGRatio = 0.0;
    double totalFlavVGRatio = 0.0;
    double totalFlavPGRatio = 0.0;

    final List<Ingredient> ingNicBases = nicBaseEntries.map((entry) {
      final entryRatio = double.parse(entry.percentageController.text) / 100;
      final entryMixRatio = _totalNicBaseRatio * entryRatio;
      final entryNicMixRatio = targetNicStr * entryRatio;
      final entryBaseVolume = batchVolume * (entryMixRatio - entryNicMixRatio);
      final entryNicVolume = batchVolume * entryNicMixRatio;
      final entryNicWeight = entryNicVolume * nicDensity;

      double entryWeight;
      final nicBase = entry.nicBase;

      if (entry.isVG) {
        totalNicBaseVGRatio += entryRatio;
        entryWeight = entryNicWeight + (entryBaseVolume * vgDensity);
      } else {
        totalNicBasePGRatio += entryRatio;
        entryWeight = entryNicWeight + (entryBaseVolume * pgDensity);
      }

      return Ingredient(
        name:
            'Nicotine Base${nicBase?.code != null ? ' (${nicBase?.code})' : ''}',
        percentage: entryMixRatio * 100,
        volume: entryBaseVolume + entryNicVolume,
        weight: entryWeight,
        type: entry.isVG ? IngredientType.vg : IngredientType.pg,
      );
    }).toList();

    final List<Ingredient> ingFlavorings = flavorings.map((flavor) {
      final volume = flavor.percentage * batchVolume;
      double weight;

      if (flavor.isVG) {
        totalFlavVGRatio += flavor.percentage;
        weight = volume * vgFlavDensity;
      } else {
        totalFlavPGRatio += flavor.percentage;
        weight = volume * pgFlavDensity;
      }

      return Ingredient(
        name: flavor.name,
        percentage: flavor.percentage,
        volume: volume,
        weight: weight,
        type: flavor.isVG ? IngredientType.vgFlavor : IngredientType.pgFlavor,
      );
    }).toList();

    return [
      ...ingNicBases,
      ...ingFlavorings,
      _getVG(
        totalNicBaseMixRatio: totalNicBaseVGRatio,
        totalFlavMixRatio: totalFlavVGRatio,
      ),
      _getPG(
        totalNicBaseMixRatio: totalNicBasePGRatio,
        totalFlavMixRatio: totalFlavPGRatio,
      ),
    ];
  }
}
