import 'package:elchemist_app/features/recipe/data/ingredient_dto.dart';

class RecipeDiyDto {
  final List<IngredientDto> ingredients;
  final double totalRatio;
  final double totalVolumeMl;
  final double totalWeightG;

  const RecipeDiyDto({
    required this.ingredients,
    required this.totalRatio,
    required this.totalVolumeMl,
    required this.totalWeightG,
  });

  factory RecipeDiyDto.fromJson(Map<String, dynamic> json) {
    final ingredientsJson = json['ingredients'] as List<dynamic>;
    final ingredients = ingredientsJson
        .map((i) => IngredientDto.fromJson((i as Map<String, dynamic>)))
        .toList();

    return RecipeDiyDto(
      ingredients: ingredients,
      totalRatio: (json['totalRatio'] as num).toDouble(),
      totalVolumeMl: (json['totalVolumeMl'] as num).toDouble(),
      totalWeightG: (json['totalWeightG'] as num).toDouble(),
    );
  }

  @override
  toString() =>
      '<RecipeDiyDto totalRatio=$totalRatio totalVolumeMl=$totalVolumeMl totalWeightG=$totalWeightG>';
}
