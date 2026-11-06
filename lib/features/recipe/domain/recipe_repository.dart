import 'package:elchemist_app/features/recipe/domain/recipe.dart';

abstract class RecipeRepository {
  Future<Recipe?> getDetails({
    required String formulaId,
    required double batchVolumeMl,
  });
}
