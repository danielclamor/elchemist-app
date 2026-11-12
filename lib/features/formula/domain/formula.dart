import 'package:elchemist_app/features/formula/data/formula_dto.dart';
import 'package:elchemist_app/features/formula/domain/flavoring.dart';
import 'package:elchemist_app/features/formula/domain/nic_base.dart';

class FormulaSummary {
  final String id;
  final String name;
  final bool isPreMix;
  final double nicLevel;
  final String brand;
  final ChillType chillType;
  final NicType nicType;

  const FormulaSummary({
    required this.id,
    required this.name,
    required this.isPreMix,
    required this.nicLevel,
    required this.brand,
    required this.chillType,
    required this.nicType,
  });

  factory FormulaSummary.fromDto(FormulaSummaryDto p) {
    return FormulaSummary(
      id: p.id,
      name: p.name,
      isPreMix: p.isPreMix,
      nicLevel: p.nicLevel,
      brand: p.brand,
      chillType: ChillType.fromDto(p.chillType),
      nicType: NicType.fromDto(p.nicType),
    );
  }
}

class Formula {
  final String id;
  final String slug;
  final String name;
  final double nicLevel;
  final String brand;
  final ChillType chillType;
  final NicType nicType;
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
    required this.brand,
    required this.chillType,
    required this.nicType,
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
        brand: d.brand,
        chillType: ChillType.fromDto(d.chillType),
        nicType: NicType.fromDto(d.nicType),
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
}

enum ChillType {
  chilled,
  nonChilled;

  @override
  String toString() {
    return switch (this) {
      ChillType.chilled => 'Chilled',
      ChillType.nonChilled => 'Non-chilled',
    };
  }

  static ChillType fromDto(ChillTypeDto c) {
    return switch (c) {
      ChillTypeDto.chilled => ChillType.chilled,
      ChillTypeDto.nonChilled => ChillType.nonChilled,
    };
  }
}

enum NicType {
  freebase,
  salt;

  @override
  String toString() {
    return switch (this) {
      NicType.freebase => 'Freebase',
      NicType.salt => 'Salt',
    };
  }

  static NicType fromDto(NicTypeDto n) {
    return switch (n) {
      NicTypeDto.freebase => NicType.freebase,
      NicTypeDto.salt => NicType.salt,
    };
  }
}
