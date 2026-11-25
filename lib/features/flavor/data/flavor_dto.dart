class FlavorDto {
  final String id;
  final String slug;
  final String name;
  final String brand;
  final ChillTypeDto chillType;
  final NicTypeDto nicType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FlavorDto({
    required this.id,
    required this.slug,
    required this.name,
    required this.brand,
    required this.chillType,
    required this.nicType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FlavorDto.fromJson(Map<String, dynamic> json) {
    return FlavorDto(
      id: json['id'],
      slug: json['slug'],
      name: json['name'],
      brand: json['brand'],
      chillType: ChillTypeDto.fromString(json['chillType']),
      nicType: NicTypeDto.fromString(json['nicType']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

enum ChillTypeDto {
  chilled,
  nonChilled;

  static ChillTypeDto fromString(String value) {
    return switch (value) {
      'CHILLED' => ChillTypeDto.chilled,
      'NON_CHILLED' => ChillTypeDto.nonChilled,
      _ => throw FormatException('Unknown ChillType: $value'),
    };
  }
}

enum NicTypeDto {
  freebase,
  salt;

  static NicTypeDto fromString(String value) {
    return switch (value) {
      'FREEBASE' => NicTypeDto.freebase,
      'SALT' => NicTypeDto.salt,
      _ => throw FormatException('Unknown NicType: $value'),
    };
  }
}
