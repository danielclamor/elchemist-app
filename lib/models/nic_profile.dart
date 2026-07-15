import 'package:elchemist_app/models/nic_base.dart';

import 'flavoring.dart';

class NicProfile {
  final String name;
  final bool isNewMix;
  final double targetNicStr;
  final double targetVG;
  final double targetPG;
  final double nicBaseStr;
  final List<NicBase> nicBaseList;
  final List<Flavoring> flavoringList;

  NicProfile({
    required this.name,
    required this.isNewMix,
    required this.targetNicStr,
    required this.targetVG,
    required this.targetPG,
    required this.nicBaseStr,
    required this.nicBaseList,
    required this.flavoringList,
  });

  factory NicProfile.fromMap(Map<String, dynamic> map) => NicProfile(
        name: map["name"] as String,
        isNewMix: map["new_mix"] as bool,
        targetNicStr: map["target_nic_str"] as double,
        targetVG: map["target_vg"] as double,
        targetPG: map["target_pg"] as double,
        nicBaseStr: map["nic_base_str"] as double,
        nicBaseList: (map["nic_bases"] as List<Map<String, dynamic>>)
            .map((nicBase) => NicBase.fromMap(nicBase))
            .toList(),
        flavoringList: (map["flavourings"] as List<Map<String, dynamic>>)
            .map((flavouring) => Flavoring.fromMap(flavouring))
            .toList(),
      );
}
