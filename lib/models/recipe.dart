import 'package:elchemist_app/models/nic_profile.dart';

enum ChillType {
  chilled,
  nonChilled;

  @override
  String toString() => this == ChillType.chilled ? "Chilled" : "Non-chilled";

  static ChillType fromString(String value) {
    switch (value) {
      case 'non-chilled':
        return ChillType.nonChilled;
      case 'chilled':
        return ChillType.chilled;
      default:
        throw ArgumentError('Unknown ChillType: $value');
    }
  }
}

enum NicType {
  salt,
  freebase;

  @override
  String toString() => this == NicType.salt ? "Salt" : "Freebase";

  static NicType fromString(String value) {
    switch (value) {
      case 'salt':
        return NicType.salt;
      case 'freebase':
        return NicType.freebase;
      default:
        throw ArgumentError('Unknown NicType: $value');
    }
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
        chilltype: ChillType.fromString(map["chill_type"]),
        nicType: NicType.fromString(map["nic_type"]),
        nicProfiles: (map["nic_profiles"] as List<Map<String, dynamic>>)
            .map((nicProfile) => NicProfile.fromMap(nicProfile))
            .toList(),
      );
}
