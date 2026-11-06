class IngredientDto {
  final String name;
  final double ratio;
  final double volumeMl;
  final double weightG;

  const IngredientDto({
    required this.name,
    required this.ratio,
    required this.volumeMl,
    required this.weightG,
  });

  factory IngredientDto.fromJson(Map<String, dynamic> json) {
    return IngredientDto(
      name: json['name'] as String,
      ratio: json['ratio'] as double,
      volumeMl: json['volumeMl'] as double,
      weightG: (json['weightG'] as num).toDouble(),
    );
  }

  @override
  toString() => '<IngredientDto $name ratio=$ratio>';
}
