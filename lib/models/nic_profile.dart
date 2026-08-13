import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/services/api_models.dart';

import 'flavoring.dart';

class NicProfile {
  final String slug;
  final String fullName;
  final String name;
  final bool isOldMix;
  final double targetNicStr;
  final double targetVg;
  final double targetPg;
  final double nicBaseNicStr;
  final List<NicBase> nicBases;
  final List<Flavoring> flavorings;

  NicProfile({
    required this.slug,
    required this.fullName,
    required this.name,
    required this.isOldMix,
    required this.targetNicStr,
    required this.targetVg,
    required this.targetPg,
    required this.nicBaseNicStr,
    required this.nicBases,
    required this.flavorings,
  });

  factory NicProfile.fromDto(NicProfileDto d) => NicProfile(
        slug: d.slug,
        fullName: d.fullName,
        name: d.name,
        isOldMix: d.isOldMix,
        targetNicStr: d.targetNicStr,
        targetVg: d.targetVg,
        targetPg: d.targetPg,
        nicBaseNicStr: d.nicBaseNicStr,
        nicBases:
            d.nicBases.map((nicBase) => NicBase.fromDto(nicBase)).toList(),
        flavorings: d.flavorings
            .map((flavoring) => Flavoring.fromDto(flavoring))
            .toList(),
      );

  double get nicLevelMultiplier => isOldMix ? 250 : 1000;

  String get label => '$name${isOldMix ? ' (Old Mix)' : ''}';

  double get nicBaseVg => nicBases
      .where((nicBase) => nicBase.isVg)
      .fold(0.0, (sum, nicBase) => sum + nicBase.ratio);

  double get nicBasePg => nicBases
      .where((nicBase) => !nicBase.isVg)
      .fold(0.0, (sum, nicBase) => sum + nicBase.ratio);

  @override
  String toString() => 'NicProfile: {fullName: $fullName}';
}
