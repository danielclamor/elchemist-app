import 'package:elchemist_app/features/formula/data/formula_dto.dart';
import 'package:elchemist_app/features/production_order/data/production_order_dto.dart';

class MixBatchDto {
  final String id;
  final String mixNumber;
  final MixBatchStatusDto status;
  final FormulaDto formula;
  final String? batchCode;
  final DateTime? mixedAt;
  final DateTime createdAt;
  final int? totalVolumeMl;
  final List<ProductionOrderSummaryDto> productionOrders;

  const MixBatchDto({
    required this.id,
    required this.mixNumber,
    required this.status,
    required this.formula,
    required this.batchCode,
    required this.mixedAt,
    required this.createdAt,
    required this.totalVolumeMl,
    required this.productionOrders,
  });

  factory MixBatchDto.fromJson(Map<String, dynamic> json) {
    final formulaJson = json['formula'];
    final productionOrderJson = json['productionOrders'] as List<dynamic>;
    final productionOrders = productionOrderJson
        .map((o) =>
            ProductionOrderSummaryDto.fromJson(o as Map<String, dynamic>))
        .toList();

    return MixBatchDto(
      id: json['id'] as String,
      mixNumber: json['mixNumber'] as String,
      status: MixBatchStatusDto.fromString(json['status'] as String),
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

class MixBatchSummaryDto {
  final String id;
  final String mixNumber;
  final MixBatchStatusDto status;
  final String formulaName;
  final bool formulaIsPreMix;
  final String? batchCode;
  final DateTime? mixedAt;
  final DateTime createdAt;

  const MixBatchSummaryDto({
    required this.id,
    required this.mixNumber,
    required this.status,
    required this.formulaName,
    required this.formulaIsPreMix,
    required this.batchCode,
    required this.mixedAt,
    required this.createdAt,
  });

  factory MixBatchSummaryDto.fromJson(Map<String, dynamic> json) {
    final formulaJson = json['formula'];

    return MixBatchSummaryDto(
      id: json['id'] as String,
      mixNumber: json['mixNumber'] as String,
      status: MixBatchStatusDto.fromString(json['status'] as String),
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
      'MixBatch: {number: $mixNumber, formulaName: $formulaName}';
}

enum MixBatchStatusDto {
  cancelled,
  completed,
  inProgress,
  mixed;

  static MixBatchStatusDto fromString(String value) {
    return switch (value) {
      'CANCELLED' => MixBatchStatusDto.cancelled,
      'COMPLETED' => MixBatchStatusDto.completed,
      'IN_PROGRESS' => MixBatchStatusDto.inProgress,
      'MIXED' => MixBatchStatusDto.mixed,
      _ => throw FormatException('Unknown MixBatchStatus: $value'),
    };
  }
}
