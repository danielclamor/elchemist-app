import 'package:elchemist_app/features/mix_batch/data/mix_batch_dto.dart';
import 'package:elchemist_app/features/formula/domain/formula.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';

class MixBatch {
  final String id;
  final String mixNumber;
  final MixBatchStatus status;
  final Formula formula;
  final String? batchCode;
  final DateTime? mixedAt;
  final DateTime createdAt;
  final int? totalVolumeMl;
  final List<ProductionOrderSummary> productionOrders;

  const MixBatch({
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

  factory MixBatch.fromDto(MixBatchDto b) {
    return MixBatch(
      id: b.id,
      mixNumber: b.mixNumber,
      status: MixBatchStatus.fromDto(b.status),
      formula: Formula.fromDto(b.formula),
      batchCode: b.batchCode,
      mixedAt: b.mixedAt,
      createdAt: b.createdAt,
      totalVolumeMl: b.totalVolumeMl,
      productionOrders: b.productionOrders
          .map((o) => ProductionOrderSummary.fromDto(o))
          .toList(),
    );
  }
}

class MixBatchSummary {
  final String id;
  final String mixNumber;
  final MixBatchStatus status;
  final String formulaFullName;
  final bool formulaIsPreMix;
  final String? batchCode;
  final DateTime? mixedAt;
  final DateTime createdAt;

  const MixBatchSummary({
    required this.id,
    required this.mixNumber,
    required this.status,
    required this.formulaFullName,
    required this.formulaIsPreMix,
    required this.batchCode,
    required this.mixedAt,
    required this.createdAt,
  });

  factory MixBatchSummary.fromDto(MixBatchSummaryDto b) {
    return MixBatchSummary(
      id: b.id,
      mixNumber: b.mixNumber,
      status: MixBatchStatus.fromDto(b.status),
      formulaFullName: b.formulaFullName,
      formulaIsPreMix: b.formulaIsPreMix,
      batchCode: b.batchCode,
      mixedAt: b.mixedAt,
      createdAt: b.createdAt,
    );
  }
}

enum MixBatchStatus {
  cancelled,
  completed,
  inProgress,
  mixed;

  static MixBatchStatus fromDto(MixBatchStatusDto value) {
    return switch (value) {
      MixBatchStatusDto.cancelled => MixBatchStatus.cancelled,
      MixBatchStatusDto.completed => MixBatchStatus.completed,
      MixBatchStatusDto.inProgress => MixBatchStatus.inProgress,
      MixBatchStatusDto.mixed => MixBatchStatus.mixed,
    };
  }
}
