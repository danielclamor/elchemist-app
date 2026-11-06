import 'package:elchemist_app/features/recipe/data/recipe_dto.dart';
import 'package:elchemist_app/features/recipe/domain/ingredient.dart';

class Recipe {
  final String formulaSlug;
  final String formulaFullName;
  final List<Ingredient> ingredients;
  final double totalRatio;
  final double totalVolumeMl;
  final double totalWeightG;

  const Recipe({
    required this.formulaSlug,
    required this.formulaFullName,
    required this.ingredients,
    required this.totalRatio,
    required this.totalVolumeMl,
    required this.totalWeightG,
  });

  factory Recipe.fromDto(RecipeDto r) {
    return Recipe(
      formulaSlug: r.formulaSlug,
      formulaFullName: r.formulaFullName,
      ingredients: r.ingredients.map((i) => Ingredient.fromDto(i)).toList(),
      totalRatio: r.totalRatio,
      totalVolumeMl: r.totalVolumeMl,
      totalWeightG: r.totalWeightG,
    );
  }

  @override
  toString() =>
      '<RecipeDto $formulaFullName totalRatio=$totalRatio totalVolumeMl=$totalVolumeMl totalWeightG=$totalWeightG>';
}
