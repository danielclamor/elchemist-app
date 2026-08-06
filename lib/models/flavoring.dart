class Flavoring {
  final String name;
  double ratio;
  bool isVG;

  Flavoring({
    required this.name,
    required this.ratio,
    required this.isVG,
  });

  factory Flavoring.fromMap(Map<String, dynamic> map) => Flavoring(
        name: map["name"] as String,
        ratio: map["ratio"] as double,
        isVG: map["is_vg"] as bool,
      );

  double get percentage => ratio * 100;
}
