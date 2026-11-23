import 'package:elchemist_app/features/formula/domain/flavoring.dart';
import 'package:elchemist_app/features/formula/domain/nic_base.dart';
import 'package:elchemist_app/features/recipe/data/mix_parameters_dto.dart';

class MixParameters {
  final double batchVolumeMl;
  final double nicBaseNicStr;
  final double nicBasePg;
  final double nicBaseVg;
  final double targetNicStr;
  final double targetPg;
  final double targetVg;
  final List<Flavoring> flavorings;
  final List<NicBase> nicBases;

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
      flavorings: p.flavorings.map((f) => Flavoring.fromDto(f)).toList(),
      nicBases: p.nicBases.map((b) => NicBase.fromDto(b)).toList(),
    );
  }
}
