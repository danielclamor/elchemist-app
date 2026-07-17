import 'package:flutter/material.dart';

enum IngredientType {
  nicotine,
  vg,
  pg,
  vgFlavor,
  pgFlavor;
}

IngredientType getIngredientType(String ingredientType) {
  if (ingredientType == "nicotine") {
    return IngredientType.nicotine;
  } else if (ingredientType == "vg") {
    return IngredientType.vg;
  } else if (ingredientType == "pg") {
    return IngredientType.pg;
  } else if (ingredientType == "vgFlavor") {
    return IngredientType.vgFlavor;
  } else {
    return IngredientType.pgFlavor;
  }
}

class Ingredient {
  final Key? id;
  final String name;
  double percentage;
  double volume;
  double weight;
  final IngredientType type;

  Ingredient({
    required this.name,
    required this.percentage,
    required this.volume,
    required this.weight,
    required this.type,
    this.id,
  });
}
