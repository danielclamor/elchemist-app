class NicBase {
  final String code;
  final String name;
  final bool isVg;
  final double percentage;

  NicBase({
    required this.code,
    required this.name,
    required this.isVg,
    required this.percentage,
  });

  factory NicBase.fromMap(Map<String, dynamic> map) => NicBase(
        code: map["code"] as String,
        name: map["name"] as String,
        isVg: map["is_vg"] as bool,
        percentage: map["percentage"] as double,
      );
}
