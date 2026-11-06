class FlavorSummaryDto {
  final String id;
  final String brand;
  final String name;
  final FlavorChillTypeDto chillType;
  final FlavorNicTypeDto nicType;

  const FlavorSummaryDto({
    required this.id,
    required this.brand,
    required this.name,
    required this.chillType,
    required this.nicType,
  });

  factory FlavorSummaryDto.fromJson(Map<String, dynamic> json) {
    return FlavorSummaryDto(
      id: json['id'] as String,
      brand: json['brand'] as String,
      name: json['name'] as String,
      chillType: FlavorChillTypeDto.fromString(json['chillType'] as String),
      nicType: FlavorNicTypeDto.fromString(json['nicType'] as String),
    );
  }
}

enum FlavorChillTypeDto {
  chilled,
  nonChilled;

  static FlavorChillTypeDto fromString(String value) {
    return switch (value) {
      'CHILLED' => FlavorChillTypeDto.chilled,
      'NON_CHILLED' => FlavorChillTypeDto.nonChilled,
      _ => throw FormatException('Unknown ChillType: $value'),
    };
  }
}

enum FlavorNicTypeDto {
  freebase,
  salt;

  static FlavorNicTypeDto fromString(String value) {
    return switch (value) {
      'FREEBASE' => FlavorNicTypeDto.freebase,
      'SALT' => FlavorNicTypeDto.salt,
      _ => throw FormatException('Unknown NicType: $value'),
    };
  }
}
