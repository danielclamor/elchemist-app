import 'package:elchemist_app/features/formula/data/formula_dto.dart';
import 'package:elchemist_app/features/production_order/data/production_order_dto.dart';

class MixSessionDto {
  final String id;
  final String sessionNumber;
  final MixSessionStatusDto status;
  final FormulaDto formula;
  final String? batchCode;
  final DateTime? mixedAt;
  final DateTime createdAt;
  final int? totalVolumeMl;
  final List<ProductionOrderSummaryDto> productionOrders;

  const MixSessionDto({
    required this.id,
    required this.sessionNumber,
    required this.status,
    required this.formula,
    required this.batchCode,
    required this.mixedAt,
    required this.createdAt,
    required this.totalVolumeMl,
    required this.productionOrders,
  });

  factory MixSessionDto.fromJson(Map<String, dynamic> json) {
    final formulaJson = json['formula'];
    final productionOrderJson = json['productionOrders'] as List<dynamic>;
    final productionOrders = productionOrderJson
        .map((o) =>
            ProductionOrderSummaryDto.fromJson(o as Map<String, dynamic>))
        .toList();

    return MixSessionDto(
      id: json['id'] as String,
      sessionNumber: json['sessionNumber'] as String,
      status: MixSessionStatusDto.fromString(json['status'] as String),
      formula:
          FormulaDto.fromJson(Map<String, dynamic>.from(formulaJson as Map)),
      batchCode: json['batchCode'] as String?,
      mixedAt: json['mixedAt'] != null
          ? DateTime.parse(json['mixedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalVolumeMl: json['totalVolumeMl'] as int?,
      productionOrders: productionOrders,
    );
  }
}

class MixSessionSummaryDto {
  final String id;
  final String sessionNumber;
  final MixSessionStatusDto status;
  final String formulaName;
  final bool formulaIsPreMix;
  final String? batchCode;
  final DateTime? mixedAt;
  final DateTime createdAt;

  const MixSessionSummaryDto({
    required this.id,
    required this.sessionNumber,
    required this.status,
    required this.formulaName,
    required this.formulaIsPreMix,
    required this.batchCode,
    required this.mixedAt,
    required this.createdAt,
  });

  factory MixSessionSummaryDto.fromJson(Map<String, dynamic> json) {
    final formulaJson = json['formula'];

    return MixSessionSummaryDto(
      id: json['id'] as String,
      sessionNumber: json['sessionNumber'] as String,
      status: MixSessionStatusDto.fromString(json['status'] as String),
      formulaName: formulaJson['name'] as String,
      formulaIsPreMix: formulaJson['isPreMix'] as bool,
      batchCode: json['batchCode'] as String?,
      mixedAt: json['mixedAt'] != null
          ? DateTime.parse(json['mixedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() =>
      'MixSession: {number: $sessionNumber, formulaName: $formulaName}';
}

enum MixSessionStatusDto {
  cancelled,
  completed,
  inProgress,
  mixed;

  static MixSessionStatusDto fromString(String value) {
    return switch (value) {
      'CANCELLED' => MixSessionStatusDto.cancelled,
      'COMPLETED' => MixSessionStatusDto.completed,
      'IN_PROGRESS' => MixSessionStatusDto.inProgress,
      'MIXED' => MixSessionStatusDto.mixed,
      _ => throw FormatException('Unknown MixSessionStatus: $value'),
    };
  }
}
