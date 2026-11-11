import 'package:elchemist_app/features/recipe/data/ingredient_dto.dart';

class RecipeDto {
  final String formulaSlug;
  final String formulaName;
  final List<IngredientDto> ingredients;
  final double totalRatio;
  final double totalVolumeMl;
  final double totalWeightG;

  const RecipeDto({
    required this.formulaSlug,
    required this.formulaName,
    required this.ingredients,
    required this.totalRatio,
    required this.totalVolumeMl,
    required this.totalWeightG,
  });

  factory RecipeDto.fromJson(Map<String, dynamic> json) {
    final formulaJson = json['formula'] as Map<String, dynamic>;

    final ingredientsJson = json['ingredients'] as List<dynamic>;
    final ingredients = ingredientsJson
        .map((i) => IngredientDto.fromJson((i as Map<String, dynamic>)))
        .toList();

    return RecipeDto(
      formulaSlug: formulaJson['slug'],
      formulaName: formulaJson['name'],
      ingredients: ingredients,
      totalRatio: (json['totalRatio'] as num).toDouble(),
      totalVolumeMl: (json['totalVolumeMl'] as num).toDouble(),
      totalWeightG: (json['totalWeightG'] as num).toDouble(),
    );
  }

  @override
  toString() =>
      '<RecipeDto $formulaName totalRatio=$totalRatio totalVolumeMl=$totalVolumeMl totalWeightG=$totalWeightG>';
}
