import 'package:elchemist_app/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipesModel extends ChangeNotifier {
  final List<Recipe> recipes = [];

  void addRecipe(Recipe recipe) {
    recipes.add(recipe);

    notifyListeners();
  }
}
