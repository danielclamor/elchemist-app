import 'package:elchemist_app/features/flavor/domain/flavor.dart';
import 'package:elchemist_app/features/formula/data/formula_dto.dart';
import 'package:elchemist_app/features/flavoring/domain/flavoring.dart';
import 'package:elchemist_app/features/nic_base/domain/nic_base.dart';

class FormulaSummary {
  final String id;
  final String name;
  final bool isPreMix;
  final double nicLevel;
  final Flavor flavor;
  const FormulaSummary({
    required this.id,
    required this.name,
    required this.isPreMix,
    required this.nicLevel,
    required this.flavor,
  });

  factory FormulaSummary.fromDto(FormulaSummaryDto p) {
    return FormulaSummary(
      id: p.id,
      name: p.name,
      isPreMix: p.isPreMix,
      nicLevel: p.nicLevel,
      flavor: Flavor.fromDto(p.flavor),
    );
  }

  String get brand => flavor.brand;
  ChillType get chillType => flavor.chillType;
  NicType get nicType => flavor.nicType;
}

class Formula {
  final String id;
  final String slug;
  final String name;
  final double nicLevel;
  final Flavor flavor;
  final bool isOldMix;
  final bool isPreMix;
  final double targetNicStr;
  final double targetVg;
  final double targetPg;
  final double nicBaseNicStr;
  final List<Flavoring> flavorings;
  final List<NicBase> nicBases;
  final double nicBaseVg;
  final double nicBasePg;

  Formula({
    required this.id,
    required this.slug,
    required this.name,
    required this.nicLevel,
    required this.flavor,
    required this.isOldMix,
    required this.isPreMix,
    required this.targetNicStr,
    required this.targetVg,
    required this.targetPg,
    required this.nicBaseNicStr,
    required this.flavorings,
    required this.nicBases,
    required this.nicBaseVg,
    required this.nicBasePg,
  });

  factory Formula.fromDto(FormulaDto d) => Formula(
        id: d.id,
        slug: d.slug,
        name: d.name,
        flavor: Flavor.fromDto(d.flavor),
        nicLevel: d.nicLevel,
        isOldMix: d.isOldMix,
        isPreMix: d.isPreMix,
        targetNicStr: d.targetNicStr,
        targetVg: d.targetVg,
        targetPg: d.targetPg,
        nicBaseNicStr: d.nicBaseNicStr,
        nicBases:
            d.nicBases.map((nicBase) => NicBase.fromDto(nicBase)).toList(),
        nicBaseVg: d.nicBaseVg,
        nicBasePg: d.nicBasePg,
        flavorings: d.flavorings
            .map((flavoring) => Flavoring.fromDto(flavoring))
            .toList(),
      );

  double get nicLevelMultiplier => isOldMix ? 250 : 1000;

  @override
  String toString() => 'Formula: {name: $name}';

  String get brand => flavor.brand;
  ChillType get chillType => flavor.chillType;
  NicType get nicType => flavor.nicType;
}
