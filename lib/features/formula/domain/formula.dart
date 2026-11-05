import 'package:elchemist_app/features/flavor/domain/flavor.dart';
import 'package:elchemist_app/features/formula/data/formula_dto.dart';
import 'package:elchemist_app/features/formula/domain/flavoring.dart';
import 'package:elchemist_app/features/formula/domain/nic_base.dart';

class FormulaSummary {
  final String id;
  final String name;
  final String fullName;
  final bool isPreMix;
  final FlavorSummary flavor;

  const FormulaSummary({
    required this.id,
    required this.name,
    required this.fullName,
    required this.isPreMix,
    required this.flavor,
  });

  factory FormulaSummary.fromDto(FormulaSummaryDto p) {
    return FormulaSummary(
      id: p.id,
      name: p.name,
      fullName: p.fullName,
      isPreMix: p.isPreMix,
      flavor: FlavorSummary.fromDto(p.flavor),
    );
  }
}

class Formula {
  final String id;
  final String slug;
  final String fullName;
  final String name;
  final bool isOldMix;
  final bool isPreMix;
  final double targetNicStr;
  final double targetVg;
  final double targetPg;
  final double nicBaseNicStr;
  final List<NicBase> nicBases;
  final List<Flavoring> flavorings;
  final FlavorSummary flavor;

  Formula({
    required this.id,
    required this.slug,
    required this.fullName,
    required this.name,
    required this.isOldMix,
    required this.isPreMix,
    required this.targetNicStr,
    required this.targetVg,
    required this.targetPg,
    required this.nicBaseNicStr,
    required this.nicBases,
    required this.flavorings,
    required this.flavor,
  });

  factory Formula.fromDto(FormulaDto d) => Formula(
        id: d.id,
        slug: d.slug,
        fullName: d.fullName,
        name: d.name,
        isOldMix: d.isOldMix,
        isPreMix: d.isPreMix,
        targetNicStr: d.targetNicStr,
        targetVg: d.targetVg,
        targetPg: d.targetPg,
        nicBaseNicStr: d.nicBaseNicStr,
        nicBases:
            d.nicBases.map((nicBase) => NicBase.fromDto(nicBase)).toList(),
        flavorings: d.flavorings
            .map((flavoring) => Flavoring.fromDto(flavoring))
            .toList(),
        flavor: FlavorSummary.fromDto(d.flavor),
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
  String toString() => 'Formula: {fullName: $fullName}';
}
