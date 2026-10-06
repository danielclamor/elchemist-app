class EliquidDto {
  final String id;
  final String upc;
  final String description;
  final String brand;
  final ChillTypeDto chillType;
  final NicTypeDto nicType;
  final BottleSizeDto bottleSize;
  final NicLevelDto nicLevel;
  final BottleColorDto bottleColor;
  final Map<String, dynamic>? nicProfile;

  const EliquidDto({
    required this.id,
    required this.upc,
    required this.description,
    required this.brand,
    required this.chillType,
    required this.nicType,
    required this.bottleSize,
    required this.nicLevel,
    required this.bottleColor,
    required this.nicProfile,
  });

  factory EliquidDto.fromJson(Map<String, dynamic> json) {
    return EliquidDto(
      id: json['id'] as String,
      upc: json['upc'] as String,
      description: json['description'] as String,
      brand: json['brand'] as String,
      chillType: ChillTypeDto.fromJson(json['chillType'] as String),
      nicType: NicTypeDto.fromJson(json['nicType'] as String),
      bottleSize: BottleSizeDto.fromJson(json['bottleSize'] as String),
      nicLevel: NicLevelDto.fromJson(json['nicLevel'] as String),
      bottleColor: BottleColorDto.fromJson(json['bottleColor'] as String),
      nicProfile: json['nicProfile'] as Map<String, dynamic>,
    );
  }
}

class EliquidSummaryDto {
  final String id;
  final String upc;
  final String description;
  final String brand;

  const EliquidSummaryDto({
    required this.id,
    required this.upc,
    required this.description,
    required this.brand,
  });

  factory EliquidSummaryDto.fromJson(Map<String, dynamic> json) {
    return EliquidSummaryDto(
      id: json['id'] as String,
      upc: json['upc'] as String,
      description: json['description'] as String,
      brand: json['brand'] as String,
    );
  }
}

enum ChillTypeDto {
  chilled,
  nonChilled;

  static ChillTypeDto fromJson(String value) {
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

  static NicTypeDto fromJson(String value) {
    return switch (value) {
      'FREEBASE' => NicTypeDto.freebase,
      'SALT' => NicTypeDto.salt,
      _ => throw FormatException('Unknown NicType: $value'),
    };
  }
}

enum BottleSizeDto {
  ml30,
  ml60,
  ml120;

  static BottleSizeDto fromJson(String value) {
    return switch (value) {
      '30_ML' => BottleSizeDto.ml30,
      '60_ML' => BottleSizeDto.ml60,
      '120_ML' => BottleSizeDto.ml120,
      _ => throw FormatException('Unknown SizeOption: $value'),
    };
  }
}

enum NicLevelDto {
  mg0,
  mg3,
  mg5,
  mg6,
  mg10,
  mg12,
  mg15,
  mg18,
  mg20,
  hit35,
  hit50;

  static NicLevelDto fromJson(String value) {
    return switch (value) {
      '0_MG' => NicLevelDto.mg0,
      '3_MG' => NicLevelDto.mg3,
      '5_MG' => NicLevelDto.mg5,
      '6_MG' => NicLevelDto.mg6,
      '10_MG' => NicLevelDto.mg10,
      '12_MG' => NicLevelDto.mg12,
      '15_MG' => NicLevelDto.mg15,
      '18_MG' => NicLevelDto.mg18,
      '20_MG' => NicLevelDto.mg20,
      'HIT_35' => NicLevelDto.hit35,
      'HIT_50' => NicLevelDto.hit50,
      _ => throw FormatException('Unknown NicLevelOption: $value'),
    };
  }
}

enum BottleColorDto {
  clear,
  black,
  white;

  @override
  String toString() {
    switch (this) {
      case BottleColorDto.clear:
        return 'Clear';
      case BottleColorDto.black:
        return 'Black';
      case BottleColorDto.white:
        return 'White';
    }
  }

  static BottleColorDto fromJson(String value) {
    return switch (value) {
      'CLEAR' => BottleColorDto.clear,
      'BLACK' => BottleColorDto.black,
      'WHITE' => BottleColorDto.white,
      _ => throw FormatException('Unknown BottleColor: $value'),
    };
  }
}
