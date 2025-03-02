class Flavoring {
  final String name;
  double? percentage;
  bool? isVG;

  Flavoring({
    required this.name,
    required this.percentage,
    required this.isVG,
  });

  factory Flavoring.fromMap(Map<String, dynamic> map) => Flavoring(
        name: map["name"] as String,
        percentage: map["percentage"] as double?,
        isVG: map["isVG"] as bool?,
      );
}
