import 'package:elchemist_app/features/recipe/data/ingredient_dto.dart';

class RecipeDto {
  final String formulaSlug;
  final String formulaFullName;
  final List<IngredientDto> ingredients;
  final double totalRatio;
  final double totalVolumeMl;
  final double totalWeightG;

  const RecipeDto({
    required this.formulaSlug,
    required this.formulaFullName,
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
      formulaFullName: formulaJson['fullName'],
      ingredients: ingredients,
      totalRatio: (json['totalRatio'] as num).toDouble(),
      totalVolumeMl: (json['totalVolumeMl'] as num).toDouble(),
      totalWeightG: (json['totalWeightG'] as num).toDouble(),
    );
  }

  @override
  toString() =>
      '<RecipeDto $formulaFullName totalRatio=$totalRatio totalVolumeMl=$totalVolumeMl totalWeightG=$totalWeightG>';
}
