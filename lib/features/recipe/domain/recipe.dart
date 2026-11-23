import 'package:elchemist_app/features/recipe/data/recipe_dto.dart';
import 'package:elchemist_app/features/recipe/domain/ingredient.dart';
import 'package:elchemist_app/features/recipe/domain/mix_parameters.dart';

class Recipe {
  final MixParameters mixParameters;
  final List<Ingredient> ingredients;
  final double totalRatio;
  final double totalVolumeMl;
  final double totalWeightG;

  const Recipe({
    required this.mixParameters,
    required this.ingredients,
    required this.totalRatio,
    required this.totalVolumeMl,
    required this.totalWeightG,
  });

  factory Recipe.fromDto(RecipeDto r) {
    return Recipe(
      mixParameters: MixParameters.fromDto(r.mixParameters),
      ingredients: r.ingredients.map((i) => Ingredient.fromDto(i)).toList(),
      totalRatio: r.totalRatio,
      totalVolumeMl: r.totalVolumeMl,
      totalWeightG: r.totalWeightG,
    );
  }

  @override
  toString() =>
      '<RecipeDto totalRatio=$totalRatio totalVolumeMl=$totalVolumeMl totalWeightG=$totalWeightG>';
}
