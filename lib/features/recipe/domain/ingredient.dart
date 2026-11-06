import 'package:elchemist_app/features/recipe/data/ingredient_dto.dart';

class Ingredient {
  final String name;
  final double ratio;
  final double volumeMl;
  final double weightG;

  const Ingredient({
    required this.name,
    required this.ratio,
    required this.volumeMl,
    required this.weightG,
  });

  factory Ingredient.fromDto(IngredientDto i) {
    return Ingredient(
      name: i.name,
      ratio: i.ratio,
      volumeMl: i.volumeMl,
      weightG: i.weightG,
    );
  }

  @override
  toString() => '<Ingredient $name ratio=$ratio>';
}
