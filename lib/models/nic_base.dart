class NicBase {
  final String code;
  final String name;
  final bool isVG;
  final double percentage;

  NicBase({
    required this.code,
    required this.name,
    required this.isVG,
    required this.percentage,
  });

  factory NicBase.fromMap(Map<String, dynamic> map) => NicBase(
        code: map["code"] as String,
        name: map["name"] as String,
        isVG: map["is_vg"] as bool,
        percentage: map["percentage"] as double,
      );
}
