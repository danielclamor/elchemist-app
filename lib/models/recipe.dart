import 'package:elchemist_app/models/nic_profile.dart';

enum ChillType {
  chilled,
  nonChilled;

  @override
  String toString() => this == ChillType.chilled ? "Chilled" : "Non-chilled";
}

ChillType getChillType(String chillType) {
  if (chillType == "chilled") {
    return ChillType.chilled;
  } else {
    return ChillType.nonChilled;
  }
}

enum NicType {
  salt,
  freebase;

  @override
  String toString() => this == NicType.salt ? "Salt" : "Freebase";
}

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
  final ChillType chilltype;
  final NicType nicType;
  final List<NicProfile> nicProfiles;

  Recipe({
    required this.name,
    required this.brand,
    required this.chilltype,
    required this.nicType,
    required this.nicProfiles,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) => Recipe(
        name: map["name"] as String,
        brand: map["brand"] as String,
        chilltype: getChillType(map["chill_type"]),
        nicType: getNicType(map["nic_type"]),
        nicProfiles: (map["nic_profiles"] as List<Map<String, dynamic>>)
            .map((nicProfile) => NicProfile.fromMap(nicProfile))
            .toList(),
      );
}
