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
  final String id;
  final String? slug;
  final String name;
  final bool isVg;
  final double ratio;

  const MixParametersFlavoring({
    required this.id,
    this.slug,
    required this.name,
    required this.isVg,
    required this.ratio,
  });

  factory MixParametersFlavoring.fromDto(MixParametersFlavoringDto d) =>
      MixParametersFlavoring(
        id: d.id,
        name: d.name,
        isVg: d.isVg,
        ratio: d.ratio,
      );

  MixParametersFlavoringDto toDto() => MixParametersFlavoringDto(
        id: id,
        slug: slug,
        name: name,
        isVg: isVg,
        ratio: ratio,
      );

  double get percentage => ratio * 100;

  @override
  String toString() =>
      'MixParametersFlavoring: {name: $name, isVg: $isVg, percentage: $percentage%}';
}

class MixParametersNicBase {
  final String id;
  final String? code;
  final String name;
  final bool isVg;
  final double ratio;

  const MixParametersNicBase({
    required this.id,
    this.code,
    required this.name,
    required this.isVg,
    required this.ratio,
  });

  factory MixParametersNicBase.fromDto(MixParametersNicBaseDto d) =>
      MixParametersNicBase(
        id: d.id,
        code: d.code,
        name: d.name,
        isVg: d.isVg,
        ratio: d.ratio,
      );

  MixParametersNicBaseDto toDto() => MixParametersNicBaseDto(
        id: id,
        code: code,
        name: name,
        isVg: isVg,
        ratio: ratio,
      );

  double get percentage => ratio * 100;

  @override
  String toString() =>
      'MixParametersNicBase: {name: $name, isVg: $isVg, percentage: $percentage%}';
}
