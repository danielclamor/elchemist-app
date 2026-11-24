import 'package:elchemist_app/core/utils/parse_double_helper.dart';

class MixParametersDto {
  final double batchVolumeMl;
  final double nicBaseNicStr;
  final double nicBasePg;
  final double nicBaseVg;
  final double targetNicStr;
  final double targetPg;
  final double targetVg;
  final List<MixParametersFlavoringDto> flavorings;
  final List<MixParametersNicBaseDto> nicBases;

  const MixParametersDto({
    required this.batchVolumeMl,
    required this.nicBaseNicStr,
    required this.nicBasePg,
    required this.nicBaseVg,
    required this.targetNicStr,
    required this.targetPg,
    required this.targetVg,
    required this.flavorings,
    required this.nicBases,
  });

  factory MixParametersDto.fromJson(Map<String, dynamic> json) {
    final flavoringsJson = json['flavorings'] as List<dynamic>?;
    final flavorings = flavoringsJson != null
        ? flavoringsJson
            .map((f) => MixParametersFlavoringDto.fromJson(
                Map<String, dynamic>.from(f as Map)))
            .toList()
        : <MixParametersFlavoringDto>[];

    final nicBasesJson = json['nicBases'] as List<dynamic>?;
    final nicBases = nicBasesJson != null
        ? nicBasesJson
            .map((b) => MixParametersNicBaseDto.fromJson(
                Map<String, dynamic>.from(b as Map)))
            .toList()
        : <MixParametersNicBaseDto>[];

    return MixParametersDto(
      batchVolumeMl: (json['batchVolumeMl'] as Object?).toDoubleOrZero(),
      nicBaseNicStr: (json['nicBaseNicStr'] as Object?).toDoubleOrZero(),
      nicBasePg: (json['nicBasePg'] as Object?).toDoubleOrZero(),
      nicBaseVg: (json['nicBaseVg'] as Object?).toDoubleOrZero(),
      targetNicStr: (json['targetNicStr'] as Object?).toDoubleOrZero(),
      targetPg: (json['targetPg'] as Object?).toDoubleOrZero(),
      targetVg: (json['targetVg'] as Object?).toDoubleOrZero(),
      flavorings: flavorings,
      nicBases: nicBases,
    );
  }
}

class MixParametersFlavoringDto {
  final String id;
  final String? slug;
  final String name;
  final bool isVg;
  final double ratio;

  const MixParametersFlavoringDto({
    required this.id,
    required this.slug,
    required this.name,
    required this.isVg,
    required this.ratio,
  });

  factory MixParametersFlavoringDto.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'slug': String? slug,
        'name': String name,
        'isVg': bool isVg,
        'ratio': num ratio,
      } =>
        MixParametersFlavoringDto(
          id: id,
          slug: slug,
          name: name,
          isVg: isVg,
          ratio: ratio.toDouble(),
        ),
      _ => throw const FormatException('Failed to load MixParametersFlavoring')
    };
  }

  /// Matches the backend's RecipeIngredientsFlavoringInput
  /// (name, isVg, ratio), for sending overrides back.
  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'name': name,
        'isVg': isVg,
        'ratio': ratio,
      };
}

class MixParametersNicBaseDto {
  final String id;
  final String? code;
  final String name;
  final bool isVg;
  final double ratio;

  const MixParametersNicBaseDto({
    required this.id,
    required this.code,
    required this.name,
    required this.isVg,
    required this.ratio,
  });

  factory MixParametersNicBaseDto.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'code': String? code,
        'name': String name,
        'isVg': bool isVg,
        'ratio': num ratio,
      } =>
        MixParametersNicBaseDto(
          id: id,
          code: code,
          name: name,
          isVg: isVg,
          ratio: ratio.toDouble(),
        ),
      _ => throw const FormatException('Failed to load MixParametersNicBase')
    };
  }

  /// Matches the backend's RecipeIngredientsNicBaseInput
  /// (code, name, isVg, ratio), for sending overrides back.
  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'isVg': isVg,
        'ratio': ratio,
      };
}
