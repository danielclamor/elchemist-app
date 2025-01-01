import 'package:elchemist_app/models/settings_by_nic.dart';

enum NicType { salt, freebase }

NicType getNicType(String nicType) {
  if (nicType == "salt") {
    return NicType.salt;
  } else {
    return NicType.freebase;
  }
}

class Recipe {
  final String name;
  final String brand;
  final NicType nicType;
  final List<String> flavours;
  final List<SettingsByNic>? settingsByNic;

  Recipe({
    required this.name,
    required this.brand,
    required this.nicType,
    required this.flavours,
    this.settingsByNic,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) => Recipe(
        name: map["name"] as String,
        brand: map["brand"] as String,
        nicType: getNicType(map["nic_type"]),
        flavours: map["flavours"] as List<String>,
      );
}
