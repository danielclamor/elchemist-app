import 'package:elchemist_app/features/mix_session/data/mix_session_dto.dart';
import 'package:elchemist_app/features/formula/domain/formula.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';

class MixSession {
  final String id;
  final String sessionNumber;
  final MixSessionStatus status;
  final Formula formula;
  final String? batchCode;
  final DateTime? mixedAt;
  final DateTime createdAt;
  final int? totalVolumeMl;
  final List<ProductionOrderSummary> productionOrders;

  const MixSession({
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

  factory MixSession.fromDto(MixSessionDto b) {
    return MixSession(
      id: b.id,
      sessionNumber: b.sessionNumber,
      status: MixSessionStatus.fromDto(b.status),
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

class MixSessionSummary {
  final String id;
  final String sessionNumber;
  final MixSessionStatus status;
  final String formulaName;
  final bool formulaIsPreMix;
  final String? batchCode;
  final DateTime? mixedAt;
  final DateTime createdAt;

  const MixSessionSummary({
    required this.id,
    required this.sessionNumber,
    required this.status,
    required this.formulaName,
    required this.formulaIsPreMix,
    required this.batchCode,
    required this.mixedAt,
    required this.createdAt,
  });

  factory MixSessionSummary.fromDto(MixSessionSummaryDto b) {
    return MixSessionSummary(
      id: b.id,
      sessionNumber: b.sessionNumber,
      status: MixSessionStatus.fromDto(b.status),
      formulaName: b.formulaName,
      formulaIsPreMix: b.formulaIsPreMix,
      batchCode: b.batchCode,
      mixedAt: b.mixedAt,
      createdAt: b.createdAt,
    );
  }

  @override
  String toString() =>
      'MixSession: {number: $sessionNumber, formulaName: $formulaName}';
}

enum MixSessionStatus {
  cancelled,
  completed,
  inProgress,
  mixed;

  static MixSessionStatus fromDto(MixSessionStatusDto value) {
    return switch (value) {
      MixSessionStatusDto.cancelled => MixSessionStatus.cancelled,
      MixSessionStatusDto.completed => MixSessionStatus.completed,
      MixSessionStatusDto.inProgress => MixSessionStatus.inProgress,
      MixSessionStatusDto.mixed => MixSessionStatus.mixed,
    };
  }
}
