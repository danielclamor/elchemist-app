class Flavour {
  final String name;
  double percentage;
  final bool isVG;

  Flavour({
    required this.name,
    required this.percentage,
    required this.isVG,
  });

  factory Flavour.fromMap(Map<String, dynamic> map) => Flavour(
        name: map["name"] as String,
        percentage: map["percentage"] as double,
        isVG: map["isVG"] as bool,
      );
}
