import 'package:elchemist_app/features/flavor/data/flavor_dto.dart';

class Flavor {
  final String id;
  final String slug;
  final String name;
  final String brand;
  final ChillType chillType;
  final NicType nicType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Flavor({
    required this.id,
    required this.slug,
    required this.name,
    required this.brand,
    required this.chillType,
    required this.nicType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Flavor.fromDto(FlavorDto f) {
    return Flavor(
      id: f.id,
      slug: f.slug,
      name: f.name,
      brand: f.brand,
      chillType: ChillType.fromDto(f.chillType),
      nicType: NicType.fromDto(f.nicType),
      createdAt: f.createdAt,
      updatedAt: f.updatedAt,
    );
  }
}

enum ChillType {
  chilled,
  nonChilled;

  static ChillType fromDto(ChillTypeDto dto) {
    return switch (dto) {
      ChillTypeDto.chilled => ChillType.chilled,
      ChillTypeDto.nonChilled => ChillType.nonChilled,
    };
  }

  @override
  String toString() => switch (this) {
        ChillType.chilled => 'Chilled',
        ChillType.nonChilled => 'Non-chilled',
      };
}

enum NicType {
  freebase,
  salt;

  static NicType fromDto(NicTypeDto dto) {
    return switch (dto) {
      NicTypeDto.freebase => NicType.freebase,
      NicTypeDto.salt => NicType.salt,
    };
  }

  @override
  String toString() => switch (this) {
        NicType.freebase => 'Freebase',
        NicType.salt => 'Salt',
      };
}
