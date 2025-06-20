import 'flavour.dart';

class SettingsByNic {
  final String nicStrength;
  final double defNicStrength;
  final double defTargetVG;
  final double defTargetPG;
  final double defNicBaseVGS;
  final double defNicBasePG;
  final double defNicBaseVGF;
  final List<Flavour> flavours;

  SettingsByNic({
    required this.nicStrength,
    required this.defNicStrength,
    required this.defTargetVG,
    required this.defTargetPG,
    required this.defNicBaseVGS,
    required this.defNicBasePG,
    required this.defNicBaseVGF,
    required this.flavours,
  });

  factory SettingsByNic.fromMap(Map<String, dynamic> map) => SettingsByNic(
        nicStrength: map["nicStrength"] as String,
        defNicStrength: map["defNicStrength"] as double,
        defTargetVG: map["defTargetVG"] as double,
        defTargetPG: map["defTargetPG"] as double,
        defNicBaseVGS: map["defNicBaseVGS"] as double,
        defNicBasePG: map["defNicBasePG"] as double,
        defNicBaseVGF: map["defNicBaseVGF"] as double,
        flavours: (map["flavours"] as List<Map<String, dynamic>>)
            .map((flavour) => Flavour.fromMap(flavour))
            .toList(),
      );
}
