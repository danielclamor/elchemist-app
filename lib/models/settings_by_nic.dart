import 'flavoring.dart';

class SettingsByNic {
  final String name;
  final double? nicStrength;
  final double? targetVG;
  final double? targetPG;
  final double? nicBaseVG;
  final double? nicBasePG;
  final List<Flavoring> flavorings;

  SettingsByNic({
    required this.name,
    required this.nicStrength,
    required this.targetVG,
    required this.targetPG,
    required this.nicBaseVG,
    required this.nicBasePG,
    required this.flavorings,
  });

  factory SettingsByNic.fromMap(Map<String, dynamic> map) => SettingsByNic(
        name: map["name"] as String,
        nicStrength: map["nicStrength"] as double,
        targetVG: map["targetVG"] as double,
        targetPG: map["targetPG"] as double,
        nicBaseVG: map["nicBaseVG"] as double,
        nicBasePG: map["nicBasePG"] as double,
        flavorings: (map["flavours"] as List<Map<String, dynamic>>)
            .map((flavouring) => Flavoring.fromMap(flavouring))
            .toList(),
      );
}
