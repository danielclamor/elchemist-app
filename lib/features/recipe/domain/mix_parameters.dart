import 'package:elchemist_app/features/recipe/data/mix_parameters_dto.dart';

class MixParameters {
  final double batchVolumeMl;
  final double nicBaseNicStr;
  final double nicBasePg;
  final double nicBaseVg;
  final double targetNicStr;
  final double targetPg;
  final double targetVg;
  final List<MixParametersFlavoring> flavorings;
  final List<MixParametersNicBase> nicBases;

  const MixParameters({
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

  factory MixParameters.fromDto(MixParametersDto p) {
    return MixParameters(
      batchVolumeMl: p.batchVolumeMl,
      nicBaseNicStr: p.nicBaseNicStr,
      nicBasePg: p.nicBasePg,
      nicBaseVg: p.nicBaseVg,
      targetNicStr: p.targetNicStr,
      targetPg: p.targetPg,
      targetVg: p.targetVg,
      flavorings:
          p.flavorings.map((f) => MixParametersFlavoring.fromDto(f)).toList(),
      nicBases: p.nicBases.map((b) => MixParametersNicBase.fromDto(b)).toList(),
    );
  }
}

class MixParametersFlavoring {
  final String name;
  final bool isVg;
  final double ratio;

  const MixParametersFlavoring({
    required this.name,
    required this.isVg,
    required this.ratio,
  });

  factory MixParametersFlavoring.fromDto(MixParametersFlavoringDto f) {
    return MixParametersFlavoring(
      name: f.name,
      isVg: f.isVg,
      ratio: f.ratio,
    );
  }
}

class MixParametersNicBase {
  final String code;
  final String name;
  final bool isVg;
  final double ratio;

  const MixParametersNicBase({
    required this.code,
    required this.name,
    required this.isVg,
    required this.ratio,
  });

  factory MixParametersNicBase.fromDto(MixParametersNicBaseDto b) {
    return MixParametersNicBase(
      code: b.code,
      name: b.name,
      isVg: b.isVg,
      ratio: b.ratio,
    );
  }
}
