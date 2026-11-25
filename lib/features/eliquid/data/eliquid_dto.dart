import 'package:elchemist_app/features/formula/data/formula_dto.dart';

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
  final String? formulaId;

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
    required this.formulaId,
  });

  factory EliquidDto.fromJson(Map<String, dynamic> json) {
    final formulaJson = json['formula'];

    return EliquidDto(
      id: json['id'] as String,
      upc: json['upc'] as String,
      description: json['description'] as String,
      brand: json['brand'] as String,
      chillType: ChillTypeDto.fromString(json['chillType'] as String),
      nicType: NicTypeDto.fromString(json['nicType'] as String),
      bottleSize: BottleSizeDto.fromString(json['bottleSize'] as String),
      nicLevel: NicLevelDto.fromString(json['nicLevel'] as String),
      bottleColor: BottleColorDto.fromString(json['bottleColor'] as String),
      formulaId: formulaJson != null ? formulaJson['id'] as String : null,
    );
  }
}

class EliquidSummaryDto {
  final String id;
  final String upc;
  final String description;
  final String brand;
  final FormulaSummaryDto? formula;

  const EliquidSummaryDto({
    required this.id,
    required this.upc,
    required this.description,
    required this.brand,
    required this.formula,
  });

  factory EliquidSummaryDto.fromJson(Map<String, dynamic> json) {
    final formulaJson = json['formula'] as Map<String, dynamic>?;

    return EliquidSummaryDto(
      id: json['id'] as String,
      upc: json['upc'] as String,
      description: json['description'] as String,
      brand: json['brand'] as String,
      formula:
          formulaJson != null ? FormulaSummaryDto.fromJson(formulaJson) : null,
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

enum BottleSizeDto {
  ml30,
  ml60,
  ml120;

  static BottleSizeDto fromString(String value) {
    return switch (value) {
      'ML_30' => BottleSizeDto.ml30,
      'ML_60' => BottleSizeDto.ml60,
      'ML_120' => BottleSizeDto.ml120,
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

  static NicLevelDto fromString(String value) {
    return switch (value) {
      'MG_0' => NicLevelDto.mg0,
      'MG_3' => NicLevelDto.mg3,
      'MG_5' => NicLevelDto.mg5,
      'MG_6' => NicLevelDto.mg6,
      'MG_10' => NicLevelDto.mg10,
      'MG_12' => NicLevelDto.mg12,
      'MG_15' => NicLevelDto.mg15,
      'MG_18' => NicLevelDto.mg18,
      'MG_20' => NicLevelDto.mg20,
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

  static BottleColorDto fromString(String value) {
    return switch (value) {
      'CLEAR' => BottleColorDto.clear,
      'BLACK' => BottleColorDto.black,
      'WHITE' => BottleColorDto.white,
      _ => throw FormatException('Unknown BottleColor: $value'),
    };
  }
}
