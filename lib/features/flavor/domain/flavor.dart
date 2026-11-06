import 'package:elchemist_app/features/flavor/data/flavor_dto.dart';

class FlavorSummary {
  final String id;
  final String brand;
  final String name;
  final FlavorChillType chillType;
  final FlavorNicType nicType;

  FlavorSummary({
    required this.id,
    required this.brand,
    required this.name,
    required this.chillType,
    required this.nicType,
  });

  factory FlavorSummary.fromDto(FlavorSummaryDto f) {
    return FlavorSummary(
      id: f.id,
      brand: f.brand,
      name: f.name,
      chillType: FlavorChillType.fromDto(f.chillType),
      nicType: FlavorNicType.fromDto(f.nicType),
    );
  }
}

enum FlavorChillType {
  chilled,
  nonChilled;

  @override
  String toString() {
    return switch (this) {
      FlavorChillType.chilled => 'Chilled',
      FlavorChillType.nonChilled => 'Non-chilled',
    };
  }

  static FlavorChillType fromDto(FlavorChillTypeDto c) {
    return switch (c) {
      FlavorChillTypeDto.chilled => FlavorChillType.chilled,
      FlavorChillTypeDto.nonChilled => FlavorChillType.nonChilled,
    };
  }
}

enum FlavorNicType {
  freebase,
  salt;

  @override
  String toString() {
    return switch (this) {
      FlavorNicType.freebase => 'Freebase',
      FlavorNicType.salt => 'Salt',
    };
  }

  static FlavorNicType fromDto(FlavorNicTypeDto n) {
    return switch (n) {
      FlavorNicTypeDto.freebase => FlavorNicType.freebase,
      FlavorNicTypeDto.salt => FlavorNicType.salt,
    };
  }
}
