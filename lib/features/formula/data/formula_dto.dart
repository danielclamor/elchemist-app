import 'package:elchemist_app/features/flavor/data/flavor_dto.dart';
import 'package:elchemist_app/features/formula/data/flavoring_dto.dart';
import 'package:elchemist_app/features/formula/data/nic_base_dto.dart';

class FormulaDto {
  final String id;
  final String slug;
  final String name;
  final String fullName;
  final bool isOldMix;
  final bool isPreMix;
  final double targetNicStr;
  final double targetVg;
  final double targetPg;
  final double nicBaseNicStr;
  final List<FlavoringDto> flavorings;
  final List<NicBaseDto> nicBases;
  final FlavorSummaryDto flavor;

  const FormulaDto({
    required this.id,
    required this.slug,
    required this.name,
    required this.fullName,
    required this.isOldMix,
    required this.isPreMix,
    required this.targetNicStr,
    required this.targetVg,
    required this.targetPg,
    required this.nicBaseNicStr,
    required this.flavorings,
    required this.nicBases,
    required this.flavor,
  });

  factory FormulaDto.fromJson(Map<String, dynamic> json) {
    final flavoringsJson = json['flavorings'] as List<dynamic>;
    final nicBasesJson = json['nicBases'] as List<dynamic>;

    return FormulaDto(
        id: json['id'] as String,
        slug: json['slug'] as String,
        name: json['name'] as String,
        fullName: json['fullName'] as String,
        isOldMix: json['isOldMix'] as bool,
        isPreMix: json['isPreMix'] as bool,
        targetNicStr: _toDouble(json['targetNicStr']),
        targetVg: _toDouble(json['targetVg']),
        targetPg: _toDouble(json['targetPg']),
        nicBaseNicStr: _toDouble(json['nicBaseNicStr']),
        flavorings: flavoringsJson
            .map((f) => FlavoringDto.fromJson((f as Map<String, dynamic>)))
            .toList(),
        nicBases: nicBasesJson
            .map((b) => NicBaseDto.fromJson((b as Map<String, dynamic>)))
            .toList(),
        flavor:
            FlavorSummaryDto.fromJson(json['flavor'] as Map<String, dynamic>));
  }

  static double _toDouble(Object? v) => (v as num).toDouble();
}

class FormulaSummaryDto {
  final String id;
  final String name;
  final String fullName;
  final bool isPreMix;
  final FlavorSummaryDto flavor;

  const FormulaSummaryDto({
    required this.id,
    required this.name,
    required this.fullName,
    required this.isPreMix,
    required this.flavor,
  });

  factory FormulaSummaryDto.fromJson(Map<String, dynamic> json) {
    final flavorJson = json['flavor'];

    return FormulaSummaryDto(
      id: json['id'] as String,
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      isPreMix: json['isPreMix'] as bool,
      flavor: FlavorSummaryDto.fromJson(
        Map<String, dynamic>.from((flavorJson as Map)),
      ),
    );
  }
}
