import 'package:flutter/material.dart';

class Ingredient {
  final Key? id;
  String name;
  double ratio;
  double volume;
  double weight;

  Ingredient({
    required this.name,
    required this.ratio,
    required this.volume,
    required this.weight,
    this.id,
  });

  double get percentage => ratio * 100;

  @override
  String toString() =>
      'Ingredient: {name: $name, percentage: $percentage%, volume: $volume, weight: $weight}';
}
