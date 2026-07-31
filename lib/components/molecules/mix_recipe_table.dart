import 'package:elchemist_app/components/atoms/el_recipe_table.dart';
import 'package:elchemist_app/constants.dart';
import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/ingredient.dart';
import 'package:elchemist_app/views/mix_view.dart';
import 'package:flutter/material.dart';

class MixRecipeTable extends StatelessWidget {
  final double batchVolume;
  final double nicBaseNicStr;
  final double targetNicStr;
  final double targetVG;
  final double targetPG;
  final List<NicBaseEntry> nicBaseEntries;
  final List<Flavoring> flavorings;

  const MixRecipeTable({
    super.key,
    required this.batchVolume,
    required this.targetNicStr,
    required this.targetVG,
    required this.targetPG,
    required this.nicBaseNicStr,
    required this.nicBaseEntries,
    required this.flavorings,
  });

  double get _totalNicBaseRatio => targetNicStr / nicBaseNicStr;

  Ingredient _getVG({
    required double totalNicBaseMixRatio,
    required double totalFlavMixRatio,
  }) {
    debugPrint('vg total nb $totalNicBaseMixRatio');
    debugPrint('vg total flav $totalFlavMixRatio');

    final ratio = _getRatio(
      totalNicBaseMixRatio,
      totalFlavMixRatio,
      true,
    );

    debugPrint('vg $ratio');

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
    debugPrint('pg total nb $totalNicBaseMixRatio');
    debugPrint('pg total flav $totalFlavMixRatio');

    final ratio = _getRatio(
      totalNicBaseMixRatio,
      totalFlavMixRatio,
      false,
    );

    debugPrint('pg $ratio');

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

  @override
  Widget build(BuildContext context) {
    double totalNicBaseVGRatio = 0.0;
    double totalNicBasePGRatio = 0.0;
    double totalFlavVGRatio = 0.0;
    double totalFlavPGRatio = 0.0;

    final List<Ingredient> ingNicBases = nicBaseEntries.map(
      (entry) {
        final entryRatio =
            (double.parse(entry.percentageController.text) / 100);

        final entryMixRatio = _totalNicBaseRatio * entryRatio;

        final entryNicMixRatio = targetNicStr * entryRatio;

        final entryBaseVolume =
            batchVolume * (entryMixRatio - entryNicMixRatio);

        final entryNicVolume = batchVolume * entryNicMixRatio;

        final entryNicWeight = entryNicVolume * nicDensity;

        double entryWeight = 0.0;

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
      },
    ).toList();

    final List<Ingredient> ingFlavorings = flavorings.map(
      (flavor) {
        final volume = flavor.percentage * batchVolume;
        double weight = 0.0;

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
      },
    ).toList();

    List<Ingredient> ingredients = [
      ...ingNicBases,
      ...ingFlavorings,
      _getVG(
        totalNicBaseMixRatio: totalNicBaseVGRatio,
        totalFlavMixRatio: totalFlavVGRatio,
      ),
      _getPG(
        totalNicBaseMixRatio: totalNicBasePGRatio,
        totalFlavMixRatio: totalFlavPGRatio,
      )
    ];

    return ElRecipeTable(
      ingredients: ingredients,
    );
  }
}
