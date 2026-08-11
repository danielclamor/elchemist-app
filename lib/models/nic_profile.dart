import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/services/api_models.dart';

import 'flavoring.dart';

class NicProfile {
  final String slug;
  final String fullName;
  final String name;
  final bool isNewMix;
  final double targetNicStr;
  final double targetVG;
  final double targetPG;
  final double nicBaseNicStr;
  final List<NicBase> nicBases;
  final List<Flavoring> flavorings;

  NicProfile({
    required this.slug,
    required this.fullName,
    required this.name,
    required this.isNewMix,
    required this.targetNicStr,
    required this.targetVG,
    required this.targetPG,
    required this.nicBaseNicStr,
    required this.nicBases,
    required this.flavorings,
  });

  factory NicProfile.fromDto(NicProfileDto d) => NicProfile(
        slug: d.slug,
        fullName: d.fullName,
        name: d.name,
        isNewMix: d.isNewMix,
        targetNicStr: d.targetNicStr,
        targetVG: d.targetVg,
        targetPG: d.targetPg,
        nicBaseNicStr: d.nicBaseNicStr,
        nicBases:
            d.nicBases.map((nicBase) => NicBase.fromDto(nicBase)).toList(),
        flavorings: d.flavorings
            .map((flavoring) => Flavoring.fromDto(flavoring))
            .toList(),
      );

  String get newMixLabel => isNewMix ? 'New Mix' : 'Old Mix';

  String get label => '$name ($newMixLabel)';

  double get nicBaseVG => nicBases
      .where((nicBase) => nicBase.isVG)
      .fold(0.0, (sum, nicBase) => sum + nicBase.ratio);

  double get nicBasePG => nicBases
      .where((nicBase) => !nicBase.isVG)
      .fold(0.0, (sum, nicBase) => sum + nicBase.ratio);

  @override
  String toString() => 'NicProfile: {name: $fullName}';
}
