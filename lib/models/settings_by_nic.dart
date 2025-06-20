import 'flavoring.dart';

class SettingsByNic {
  final String name;
  final double? nicStrength;
  final double? targetVG;
  final double? targetPG;
  final double? nicBaseVGS;
  final double? nicBasePG;
  final double? nicBaseVGF;
  final List<Flavoring> flavorings;

  SettingsByNic({
    required this.name,
    required this.nicStrength,
    required this.targetVG,
    required this.targetPG,
    required this.nicBaseVGS,
    required this.nicBasePG,
    required this.nicBaseVGF,
    required this.flavorings,
  });

  factory SettingsByNic.fromMap(Map<String, dynamic> map) => SettingsByNic(
        name: map["name"] as String,
        nicStrength: map["nicStrength"] as double,
        targetVG: map["targetVG"] as double,
        targetPG: map["targetPG"] as double,
        nicBaseVGS: map["nicBaseVGS"] as double,
        nicBasePG: map["nicBasePG"] as double,
        nicBaseVGF: map["nicBaseVGF"] as double,
        flavorings: (map["flavours"] as List<Map<String, dynamic>>)
            .map((flavouring) => Flavoring.fromMap(flavouring))
            .toList(),
      );
}
