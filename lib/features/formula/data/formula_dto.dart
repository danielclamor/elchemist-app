import 'package:elchemist_app/features/flavoring/data/flavoring_dto.dart';
import 'package:elchemist_app/features/nic_base/data/nic_base_dto.dart';

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
  final String flavorId;

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
    required this.flavorId,
  });

  factory FormulaDto.fromJson(Map<String, dynamic> json) {
    final flavorJson = json['flavor'] as Map;

    final flavoringsJson = json['flavorings'] as List<dynamic>;
    final flavorings = flavoringsJson
        .map((f) => FlavoringDto.fromJson(Map<String, dynamic>.from(f as Map)))
        .toList();

    final nicBasesJson = json['nicBases'] as List<dynamic>;
    final nicBases = nicBasesJson
        .map((b) => NicBaseDto.fromJson(Map<String, dynamic>.from(b as Map)))
        .toList();

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
      flavorings: flavorings,
      nicBases: nicBases,
      nicBaseVg: _toDouble(json['nicBaseVg']),
      nicBasePg: _toDouble(json['nicBasePg']),
      flavorId: flavorJson['id'],
    );
  }

  static double _toDouble(Object? v) => (v as num).toDouble();
}

class FormulaSummaryDto {
  final String id;
  final String name;
  final bool isPreMix;
  final double nicLevel;
  final String brand;
  final ChillTypeDto chillType;
  final NicTypeDto nicType;
  final String flavorId;

  const FormulaSummaryDto({
    required this.id,
    required this.name,
    required this.isPreMix,
    required this.nicLevel,
    required this.brand,
    required this.chillType,
    required this.nicType,
    required this.flavorId,
  });

  factory FormulaSummaryDto.fromJson(Map<String, dynamic> json) {
    final flavorJson = json['flavor'] as Map;

    return FormulaSummaryDto(
      id: json['id'] as String,
      name: json['name'] as String,
      isPreMix: json['isPreMix'] as bool,
      nicLevel: _toDouble(json['nicLevel']),
      brand: json['brand'] as String,
      chillType: ChillTypeDto.fromString(json['chillType'] as String),
      nicType: NicTypeDto.fromString(json['nicType'] as String),
      flavorId: flavorJson['id'],
    );
  }

  static double _toDouble(Object? v) => (v as num).toDouble();
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
