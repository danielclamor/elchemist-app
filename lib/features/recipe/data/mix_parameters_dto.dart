import 'package:elchemist_app/core/utils/parse_double_helper.dart';
import 'package:elchemist_app/features/formula/data/flavoring_dto.dart';
import 'package:elchemist_app/features/formula/data/nic_base_dto.dart';

class MixParametersDto {
  final double batchVolumeMl;
  final double nicBaseNicStr;
  final double nicBasePg;
  final double nicBaseVg;
  final double targetNicStr;
  final double targetPg;
  final double targetVg;
  final List<FlavoringDto> flavorings;
  final List<NicBaseDto> nicBases;

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
    final nicBasesJson = json['nicBases'] as List<dynamic>?;

    return MixParametersDto(
      batchVolumeMl: (json['batchVolumeMl'] as Object?).toDoubleOrZero(),
      nicBaseNicStr: (json['nicBaseNicStr'] as Object?).toDoubleOrZero(),
      nicBasePg: (json['nicBasePg'] as Object?).toDoubleOrZero(),
      nicBaseVg: (json['nicBaseVg'] as Object?).toDoubleOrZero(),
      targetNicStr: (json['targetNicStr'] as Object?).toDoubleOrZero(),
      targetPg: (json['targetPg'] as Object?).toDoubleOrZero(),
      targetVg: (json['targetVg'] as Object?).toDoubleOrZero(),
      flavorings: flavoringsJson != null
          ? flavoringsJson
              .map((f) =>
                  FlavoringDto.fromJson(Map<String, dynamic>.from(f as Map)))
              .toList()
          : [],
      nicBases: nicBasesJson != null
          ? nicBasesJson
              .map((b) =>
                  NicBaseDto.fromJson(Map<String, dynamic>.from(b as Map)))
              .toList()
          : [],
    );
  }
}
