import 'package:elchemist_app/features/recipe/domain/recipe.dart';
import 'package:elchemist_app/features/recipe/domain/recipe_diy.dart';

abstract class RecipeRepository {
  Future<Recipe?> getDetails({
    required String formulaId,
    required double batchVolumeMl,
  });

  Future<RecipeDiy?> getDiyDetails({
    required double batchVolumeMl,
    required double targetNicStr,
    required double targetPg,
    required double targetVg,
    required double nicBaseNicStr,
    required double nicBasePg,
    required double nicBaseVg,
    required List<dynamic> flavorings,
  });
}
