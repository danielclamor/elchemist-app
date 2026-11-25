import 'package:elchemist_app/features/formula/data/formula_dto.dart';
import 'package:elchemist_app/features/flavoring/domain/flavoring.dart';
import 'package:elchemist_app/features/nic_base/domain/nic_base.dart';

class FormulaSummary {
  final String id;
  final String name;
  final bool isPreMix;
  final double nicLevel;
  final String brand;
  final ChillType chillType;
  final NicType nicType;
  final String flavorId;

  const FormulaSummary({
    required this.id,
    required this.name,
    required this.isPreMix,
    required this.nicLevel,
    required this.brand,
    required this.chillType,
    required this.nicType,
    required this.flavorId,
  });

  factory FormulaSummary.fromDto(FormulaSummaryDto f) {
    return FormulaSummary(
      id: f.id,
      name: f.name,
      isPreMix: f.isPreMix,
      nicLevel: f.nicLevel,
      brand: f.brand,
      chillType: ChillType.fromDto(f.chillType),
      nicType: NicType.fromDto(f.nicType),
      flavorId: f.flavorId,
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
  final String flavorId;

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
    required this.flavorId,
  });

  factory Formula.fromDto(FormulaDto f) => Formula(
        id: f.id,
        slug: f.slug,
        name: f.name,
        brand: f.brand,
        chillType: ChillType.fromDto(f.chillType),
        nicType: NicType.fromDto(f.nicType),
        nicLevel: f.nicLevel,
        isOldMix: f.isOldMix,
        isPreMix: f.isPreMix,
        targetNicStr: f.targetNicStr,
        targetVg: f.targetVg,
        targetPg: f.targetPg,
        nicBaseNicStr: f.nicBaseNicStr,
        nicBases:
            f.nicBases.map((nicBase) => NicBase.fromDto(nicBase)).toList(),
        nicBaseVg: f.nicBaseVg,
        nicBasePg: f.nicBasePg,
        flavorings: f.flavorings
            .map((flavoring) => Flavoring.fromDto(flavoring))
            .toList(),
        flavorId: f.flavorId,
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
