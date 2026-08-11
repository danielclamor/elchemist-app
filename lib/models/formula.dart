import 'package:elchemist_app/models/nic_profile.dart';
import 'package:elchemist_app/services/api_models.dart';

enum ChillType {
  chilled,
  nonChilled;

  @override
  String toString() => this == ChillType.chilled ? "Chilled" : "Non-chilled";

  static ChillType fromString(String value) {
    switch (value) {
      case 'NON_CHILLED':
        return ChillType.nonChilled;
      case 'CHILLED':
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
      case 'SALT':
        return NicType.salt;
      case 'FREEBASE':
        return NicType.freebase;
      default:
        throw ArgumentError('Unknown NicType: $value');
    }
  }
}

class Formula {
  final String slug;
  final String name;
  final String brand;
  final ChillType chillType;
  final NicType nicType;
  final List<NicProfile> nicProfiles;

  Formula({
    required this.slug,
    required this.name,
    required this.brand,
    required this.chillType,
    required this.nicType,
    required this.nicProfiles,
  });

  factory Formula.fromDto(FormulaDto d) => Formula(
        slug: d.slug,
        name: d.name,
        brand: d.brand,
        chillType: ChillType.fromString(d.chillType),
        nicType: NicType.fromString(d.nicType),
        nicProfiles: d.nicProfiles
            .map((nicProfile) => NicProfile.fromDto(nicProfile))
            .toList(),
      );

  @override
  String toString() => 'Formula: {name: $name, chillType: $chillType}';
}
