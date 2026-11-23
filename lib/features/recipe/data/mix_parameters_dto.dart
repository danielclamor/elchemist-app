import 'package:elchemist_app/core/utils/parse_double_helper.dart';

class MixParametersDto {
  final double batchVolumeMl;
  final double nicBaseNicStr;
  final double targetNicStr;
  final double targetPg;
  final double targetVg;
  final List<MixParametersFlavoringDto> flavorings;
  final List<MixParametersNicBaseDto> nicBases;

  const MixParametersDto({
    required this.batchVolumeMl,
    required this.nicBaseNicStr,
    required this.targetNicStr,
    required this.targetPg,
    required this.targetVg,
    required this.flavorings,
    required this.nicBases,
  });

  factory MixParametersDto.fromJson(Map<String, dynamic> json) {
    final flavoringsJson = json['flavorings'] as List<dynamic>?;
    final nicBasesJson = json['nicBases'] as List<dynamic>?;

    return MixParametersDto(
      batchVolumeMl: (json['batchVolumeMl'] as Object?).toDoubleOrZero(),
      nicBaseNicStr: (json['nicBaseNicStr'] as Object?).toDoubleOrZero(),
      targetNicStr: (json['targetNicStr'] as Object?).toDoubleOrZero(),
      targetPg: (json['targetPg'] as Object?).toDoubleOrZero(),
      targetVg: (json['targetVg'] as Object?).toDoubleOrZero(),
      flavorings: flavoringsJson != null
          ? flavoringsJson
              .map((f) => MixParametersFlavoringDto.fromJson(
                  Map<String, dynamic>.from(f as Map)))
              .toList()
          : [],
      nicBases: nicBasesJson != null
          ? nicBasesJson
              .map((b) => MixParametersNicBaseDto.fromJson(
                  Map<String, dynamic>.from(b as Map)))
              .toList()
          : [],
    );
  }
}

class MixParametersFlavoringDto {
  final String name;
  final bool isVg;
  final double ratio;

  const MixParametersFlavoringDto({
    required this.name,
    required this.isVg,
    required this.ratio,
  });

  factory MixParametersFlavoringDto.fromJson(Map<String, dynamic> json) {
    return MixParametersFlavoringDto(
      name: json['name'] as String? ?? 'Unavailable',
      isVg: json['isVg'] as bool? ?? false,
      ratio: (json['ratio'] as Object?).toDoubleOrZero(),
    );
  }
}

class MixParametersNicBaseDto {
  final String code;
  final String name;
  final bool isVg;
  final double ratio;

  const MixParametersNicBaseDto({
    required this.code,
    required this.name,
    required this.isVg,
    required this.ratio,
  });

  factory MixParametersNicBaseDto.fromJson(Map<String, dynamic> json) {
    return MixParametersNicBaseDto(
      code: json['code'] as String? ?? 'Unavailable',
      name: json['name'] as String? ?? 'Unavaialble',
      isVg: json['isVg'] as bool? ?? false,
      ratio: (json['ratio'] as Object?).toDoubleOrZero(),
    );
  }
}
