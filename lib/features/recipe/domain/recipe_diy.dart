import 'package:elchemist_app/features/recipe/data/recipe_diy_dto.dart';
import 'package:elchemist_app/features/recipe/domain/ingredient.dart';

class RecipeDiy {
  final List<Ingredient> ingredients;
  final double totalRatio;
  final double totalVolumeMl;
  final double totalWeightG;

  const RecipeDiy({
    required this.ingredients,
    required this.totalRatio,
    required this.totalVolumeMl,
    required this.totalWeightG,
  });

  factory RecipeDiy.fromDto(RecipeDiyDto r) {
    return RecipeDiy(
      ingredients: r.ingredients.map((i) => Ingredient.fromDto(i)).toList(),
      totalRatio: r.totalRatio,
      totalVolumeMl: r.totalVolumeMl,
      totalWeightG: r.totalWeightG,
    );
  }

  @override
  toString() =>
      '<RecipeDiyDto totalRatio=$totalRatio totalVolumeMl=$totalVolumeMl totalWeightG=$totalWeightG>';
}
