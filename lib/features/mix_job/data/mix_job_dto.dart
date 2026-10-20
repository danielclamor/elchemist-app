class MixJobDto {
  final String id;
  final String jobNumber;
  final MixJobStatusDto status;
  final int orderedQuantity;
  final int producedQuantity;
  final String batchNumber;
  final Map recipeSnapshot;
  final double totalVolumeMl;
  final double totalWeightG;
  final DateTime createdAt;
  final String productionOrderId;

  const MixJobDto({
    required this.id,
    required this.jobNumber,
    required this.status,
    required this.orderedQuantity,
    required this.producedQuantity,
    required this.batchNumber,
    required this.recipeSnapshot,
    required this.totalVolumeMl,
    required this.totalWeightG,
    required this.createdAt,
    required this.productionOrderId,
  });

  factory MixJobDto.fromJson(Map<String, dynamic> json) {
    return MixJobDto(
      id: json['id'] as String,
      jobNumber: json['jobNumber'] as String,
      status: MixJobStatusDto.fromString(json['status'] as String),
      orderedQuantity: json['orderedQuantity'] as int,
      producedQuantity: json['producedQuantity'] as int,
      batchNumber: json['batchNumber'] as String,
      recipeSnapshot: json['recipeSnapshot'] as Map,
      totalVolumeMl: _toDouble(['totalVolumeMl']),
      totalWeightG: _toDouble(json['totalWeightG']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      productionOrderId: json['productionOrderId'] as String,
    );
  }

  static double _toDouble(Object? v) => (v as num).toDouble();
}

class MixJobSummaryDto {
  final String id;
  final String jobNumber;
  final int orderedQuantity;
  final int? producedQuantity;
  final MixJobStatusDto status;
  final bool isPriority;
  final String eliquidDescription;
  final DateTime createdAt;

  const MixJobSummaryDto({
    required this.id,
    required this.jobNumber,
    required this.orderedQuantity,
    required this.producedQuantity,
    required this.status,
    required this.isPriority,
    required this.eliquidDescription,
    required this.createdAt,
  });

  factory MixJobSummaryDto.fromJson(Map<String, dynamic> json) {
    final productionOrderJson = json['productionOrder'];

    return MixJobSummaryDto(
      id: json['id'] as String,
      jobNumber: json['jsonNumber'] as String,
      orderedQuantity: json['mixOrderedQuantity'] as int,
      producedQuantity: json['producedQuantity'] as int?,
      status: MixJobStatusDto.fromString(json['status'] as String),
      isPriority: productionOrderJson['isPriority'] as bool,
      eliquidDescription:
          productionOrderJson['eliquid']['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

enum MixJobStatusDto {
  cancelled,
  completed,
  inProgress,
  mixed,
  reassigned;

  static MixJobStatusDto fromString(String value) {
    return switch (value) {
      'CANCELLED' => MixJobStatusDto.cancelled,
      'DELIVERED' => MixJobStatusDto.completed,
      'FULFILLED' => MixJobStatusDto.inProgress,
      'IN_PROGRESS' => MixJobStatusDto.mixed,
      'PENDING' => MixJobStatusDto.reassigned,
      _ => throw FormatException('Unknown MixJobStatus: $value'),
    };
  }
}
