import 'package:elchemist_app/features/eliquid/data/eliquid_dto.dart';

class Eliquid {
  final String id;
  final String upc;
  final String description;
  final String brand;
  final ChillType chillType;
  final NicType nicType;
  final BottleSize bottleSize;
  final NicLevel nicLevel;
  final BottleColor bottleColor;
  final String? nicProfileSlug;

  const Eliquid({
    required this.id,
    required this.upc,
    required this.description,
    required this.brand,
    required this.chillType,
    required this.nicType,
    required this.bottleSize,
    required this.nicLevel,
    required this.bottleColor,
    required this.nicProfileSlug,
  });

  factory Eliquid.fromDto(EliquidDto e) {
    return Eliquid(
      id: e.id,
      upc: e.upc,
      description: e.description,
      brand: e.brand,
      chillType: ChillType.fromDto(e.chillType),
      nicType: NicType.fromDto(e.nicType),
      bottleSize: BottleSize.fromDto(e.bottleSize),
      nicLevel: NicLevel.fromDto(e.nicLevel),
      bottleColor: BottleColor.fromDto(e.bottleColor),
      nicProfileSlug: e.nicProfile != null ? e.nicProfile!['slug'] : null,
    );
  }
}

class EliquidSummary {
  final String id;
  final String upc;
  final String description;
  final String brand;

  const EliquidSummary({
    required this.id,
    required this.upc,
    required this.description,
    required this.brand,
  });

  factory EliquidSummary.fromDto(EliquidSummaryDto e) {
    return EliquidSummary(
      id: e.id,
      upc: e.upc,
      description: e.description,
      brand: e.brand,
    );
  }
}

enum ChillType {
  chilled,
  nonChilled;

  @override
  String toString() {
    return switch (this) {
      ChillType.chilled => 'Chilled',
      ChillType.nonChilled => 'Non-chilled',
    };
  }

  static ChillType fromDto(ChillTypeDto c) {
    return switch (c) {
      ChillTypeDto.chilled => ChillType.chilled,
      ChillTypeDto.nonChilled => ChillType.nonChilled,
    };
  }
}

enum NicType {
  freebase,
  salt;

  @override
  String toString() {
    return switch (this) {
      NicType.freebase => 'Freebase',
      NicType.salt => 'Salt',
    };
  }

  static NicType fromDto(NicTypeDto n) {
    return switch (n) {
      NicTypeDto.freebase => NicType.freebase,
      NicTypeDto.salt => NicType.salt,
    };
  }
}

enum BottleSize {
  ml30,
  ml60,
  ml120;

  @override
  String toString() {
    return switch (this) {
      BottleSize.ml30 => '30mL',
      BottleSize.ml60 => '60mL',
      BottleSize.ml120 => '120mL',
    };
  }

  static BottleSize fromDto(BottleSizeDto s) {
    return switch (s) {
      BottleSizeDto.ml30 => BottleSize.ml30,
      BottleSizeDto.ml60 => BottleSize.ml60,
      BottleSizeDto.ml120 => BottleSize.ml120,
    };
  }
}

enum NicLevel {
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

  @override
  String toString() {
    return switch (this) {
      NicLevel.mg0 => '0mg',
      NicLevel.mg3 => '3mg',
      NicLevel.mg5 => '5mg',
      NicLevel.mg6 => '6mg',
      NicLevel.mg10 => '10mg',
      NicLevel.mg12 => '12mg',
      NicLevel.mg15 => '15mg',
      NicLevel.mg18 => '18mg',
      NicLevel.mg20 => '20mg',
      NicLevel.hit35 => 'Hit35',
      NicLevel.hit50 => 'Hit50',
    };
  }

  static NicLevel fromDto(NicLevelDto n) {
    return switch (n) {
      NicLevelDto.mg0 => NicLevel.mg0,
      NicLevelDto.mg3 => NicLevel.mg3,
      NicLevelDto.mg5 => NicLevel.mg5,
      NicLevelDto.mg6 => NicLevel.mg6,
      NicLevelDto.mg10 => NicLevel.mg10,
      NicLevelDto.mg12 => NicLevel.mg12,
      NicLevelDto.mg15 => NicLevel.mg15,
      NicLevelDto.mg18 => NicLevel.mg18,
      NicLevelDto.mg20 => NicLevel.mg20,
      NicLevelDto.hit35 => NicLevel.hit35,
      NicLevelDto.hit50 => NicLevel.hit50,
    };
  }
}

enum BottleColor {
  clear,
  black,
  white;

  @override
  String toString() {
    return switch (this) {
      BottleColor.clear => 'Clear',
      BottleColor.black => 'Black',
      BottleColor.white => 'White',
    };
  }

  static BottleColor fromDto(BottleColorDto b) {
    return switch (b) {
      BottleColorDto.clear => BottleColor.clear,
      BottleColorDto.black => BottleColor.black,
      BottleColorDto.white => BottleColor.white,
    };
  }
}
