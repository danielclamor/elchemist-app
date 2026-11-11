import 'package:elchemist_app/features/recipe/data/recipe_dto.dart';
import 'package:elchemist_app/features/recipe/domain/ingredient.dart';

class Recipe {
  final String formulaSlug;
  final String formulaName;
  final List<Ingredient> ingredients;
  final double totalRatio;
  final double totalVolumeMl;
  final double totalWeightG;

  const Recipe({
    required this.formulaSlug,
    required this.formulaName,
    required this.ingredients,
    required this.totalRatio,
    required this.totalVolumeMl,
    required this.totalWeightG,
  });

  factory Recipe.fromDto(RecipeDto r) {
    return Recipe(
      formulaSlug: r.formulaSlug,
      formulaName: r.formulaName,
      ingredients: r.ingredients.map((i) => Ingredient.fromDto(i)).toList(),
      totalRatio: r.totalRatio,
      totalVolumeMl: r.totalVolumeMl,
      totalWeightG: r.totalWeightG,
    );
  }

  @override
  toString() =>
      '<RecipeDto $formulaName totalRatio=$totalRatio totalVolumeMl=$totalVolumeMl totalWeightG=$totalWeightG>';
}
