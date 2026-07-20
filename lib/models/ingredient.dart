import 'package:flutter/material.dart';

enum IngredientType {
  nicotine,
  vg,
  pg,
  vgFlavor,
  pgFlavor;

  @override
  String toString() {
    switch (this) {
      case IngredientType.nicotine:
        return "nicotine";
      case IngredientType.vg:
        return "vg";
      case IngredientType.pg:
        return "pg";
      case IngredientType.vgFlavor:
        return "vg flavor";
      case IngredientType.pgFlavor:
        return "pg flavor";
    }
  }
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
  String name;
  double percentage;
  double volume;
  double weight;
  IngredientType type;

  Ingredient({
    required this.name,
    required this.percentage,
    required this.volume,
    required this.weight,
    required this.type,
    this.id,
  });

  @override
  String toString() =>
      'Ingredient: {name: $name, percentage: $percentage, volume: $volume, weight: $weight, type: $type}';
}
