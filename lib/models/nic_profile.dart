import 'package:elchemist_app/models/nic_base.dart';

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

  factory NicProfile.fromMap(Map<String, dynamic> map) => NicProfile(
        slug: map["slug"] as String,
        fullName: map["full_name"] as String,
        name: map["name"] as String,
        isNewMix: map["is_new_mix"] as bool,
        targetNicStr: map["target_nic_str"] as double,
        targetVG: map["target_vg"] as double,
        targetPG: map["target_pg"] as double,
        nicBaseNicStr: map["nic_base_nic_str"] as double,
        nicBases: (map["nic_bases"] as List).isEmpty
            ? []
            : (map["nic_bases"] as List<Map<String, dynamic>>)
                .map((nicBase) => NicBase.fromMap(nicBase))
                .toList(),
        flavorings: (map["flavorings"] as List).isEmpty
            ? []
            : (map["flavorings"] as List<Map<String, dynamic>>)
                .map((flavouring) => Flavoring.fromMap(flavouring))
                .toList(),
      );

  String get newMixLabel => isNewMix ? 'New Mix' : 'Old Mix';

  String get label => '$name ($newMixLabel)';
}
