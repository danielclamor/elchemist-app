import 'package:elchemist_app/features/formula/data/flavoring_dto.dart';
import 'package:elchemist_app/features/formula/data/nic_base_dto.dart';

class FormulaDto {
  final String id;
  final String slug;
  final String name;
  final double nicLevel;
  final String brand;
  final ChillTypeDto chillType;
  final NicTypeDto nicType;
  final bool isOldMix;
  final bool isPreMix;
  final double targetNicStr;
  final double targetVg;
  final double targetPg;
  final double nicBaseNicStr;
  final List<FlavoringDto> flavorings;
  final List<NicBaseDto> nicBases;
  final double nicBaseVg;
  final double nicBasePg;

  const FormulaDto({
    required this.id,
    required this.slug,
    required this.name,
    required this.nicLevel,
    required this.brand,
    required this.chillType,
    required this.nicType,
    required this.isOldMix,
    required this.isPreMix,
    required this.targetNicStr,
    required this.targetVg,
    required this.targetPg,
    required this.nicBaseNicStr,
    required this.flavorings,
    required this.nicBases,
    required this.nicBaseVg,
    required this.nicBasePg,
  });

  factory FormulaDto.fromJson(Map<String, dynamic> json) {
    final flavoringsJson = json['flavorings'] as List<dynamic>;
    final nicBasesJson = json['nicBases'] as List<dynamic>;

    return FormulaDto(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      nicLevel: _toDouble(json['nicLevel']),
      brand: json['brand'] as String,
      chillType: ChillTypeDto.fromString(json['chillType'] as String),
      nicType: NicTypeDto.fromString(json['nicType'] as String),
      isOldMix: json['isOldMix'] as bool,
      isPreMix: json['isPreMix'] as bool,
      targetNicStr: _toDouble(json['targetNicStr']),
      targetVg: _toDouble(json['targetVg']),
      targetPg: _toDouble(json['targetPg']),
      nicBaseNicStr: _toDouble(json['nicBaseNicStr']),
      flavorings: flavoringsJson
          .map((f) => FlavoringDto.fromJson((f as Map<String, dynamic>)))
          .toList(),
      nicBases: nicBasesJson
          .map((b) => NicBaseDto.fromJson((b as Map<String, dynamic>)))
          .toList(),
      nicBaseVg: json['nicBaseVg'],
      nicBasePg: json['nicBasePg'],
    );
  }

  static double _toDouble(Object? v) => (v as num).toDouble();
}

class FormulaSummaryDto {
  final String id;
  final String name;
  final bool isPreMix;

  const FormulaSummaryDto({
    required this.id,
    required this.name,
    required this.isPreMix,
  });

  factory FormulaSummaryDto.fromJson(Map<String, dynamic> json) {
    return FormulaSummaryDto(
      id: json['id'] as String,
      name: json['name'] as String,
      isPreMix: json['isPreMix'] as bool,
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
