import 'package:elchemist_app/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipesModel extends ChangeNotifier {
  final List<Recipe> recipes = [
    Recipe(
      name: "Vibe Frosted Mug Salt",
      brand: "VIBE",
      nicType: NicType.salt,
      flavours: ["Vibe Frosted Mug Conc"],
    ),
  ];

  void addRecipe(Recipe recipe) {
    recipes.add(recipe);

    notifyListeners();
  }
}
