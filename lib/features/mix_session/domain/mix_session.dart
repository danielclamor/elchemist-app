import 'package:elchemist_app/features/mix_session/data/mix_session_dto.dart';
import 'package:elchemist_app/features/formula/domain/formula.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';

class MixSession {
  final String id;
  final String sessionNumber;
  final MixSessionStatus status;
  final Formula formula;
  final String? batchCode;
  final int? batchVolumeMl;
  final bool isArchived;
  final DateTime? mixedAt;
  final DateTime createdAt;
  final List<ProductionOrderSummary> productionOrders;
  final int totalOrdersVolumeMl;

  const MixSession({
    required this.id,
    required this.sessionNumber,
    required this.status,
    required this.formula,
    required this.batchCode,
    required this.batchVolumeMl,
    required this.isArchived,
    required this.mixedAt,
    required this.createdAt,
    required this.productionOrders,
    required this.totalOrdersVolumeMl,
  });

  factory MixSession.fromDto(MixSessionDto b) {
    return MixSession(
      id: b.id,
      sessionNumber: b.sessionNumber,
      status: MixSessionStatus.fromDto(b.status),
      formula: Formula.fromDto(b.formula),
      batchCode: b.batchCode,
      batchVolumeMl: b.batchVolumeMl,
      isArchived: b.isArchived,
      mixedAt: b.mixedAt,
      createdAt: b.createdAt,
      productionOrders: b.productionOrders
          .map((o) => ProductionOrderSummary.fromDto(o))
          .toList(),
      totalOrdersVolumeMl: b.totalOrdersVolumeMl,
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
  final bool isArchived;
  final DateTime? mixedAt;
  final DateTime createdAt;

  const MixSessionSummary({
    required this.id,
    required this.sessionNumber,
    required this.status,
    required this.formulaName,
    required this.formulaIsPreMix,
    required this.batchCode,
    required this.isArchived,
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
      isArchived: b.isArchived,
      mixedAt: b.mixedAt,
      createdAt: b.createdAt,
    );
  }

  @override
  String toString() =>
      'MixSession: {number: $sessionNumber, formulaName: $formulaName}';
}

enum MixSessionStatus {
  inProgress,
  mixed;

  static MixSessionStatus fromDto(MixSessionStatusDto value) {
    return switch (value) {
      MixSessionStatusDto.inProgress => MixSessionStatus.inProgress,
      MixSessionStatusDto.mixed => MixSessionStatus.mixed,
    };
  }

  @override
  String toString() {
    return switch (this) {
      MixSessionStatus.inProgress => 'In progress',
      MixSessionStatus.mixed => 'Mixed',
    };
  }
}
