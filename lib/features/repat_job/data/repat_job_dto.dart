class RepatJobDto {
  final String id;
  final String jobNumber;
  final RepatJobStatusDto status;
  final int orderedQuantity;
  final int incomingQuantity;
  final DateTime createdAt;
  final String productionOrderId;

  const RepatJobDto({
    required this.id,
    required this.jobNumber,
    required this.status,
    required this.orderedQuantity,
    required this.incomingQuantity,
    required this.createdAt,
    required this.productionOrderId,
  });

  factory RepatJobDto.fromJson(Map<String, dynamic> json) {
    return RepatJobDto(
      id: json['id'] as String,
      jobNumber: json['jobNumber'] as String,
      status: RepatJobStatusDto.fromString(json['status'] as String),
      orderedQuantity: json['orderedQuantity'] as int,
      incomingQuantity: json['producedQuantity'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      productionOrderId: json['productionOrderId'] as String,
    );
  }
}

class RepatJobSummaryDto {
  final String id;
  final String jobNumber;
  final int orderedQuantity;
  final int? incomingQuantity;
  final RepatJobStatusDto status;
  final String eliquidDescription;
  final DateTime createdAt;

  const RepatJobSummaryDto({
    required this.id,
    required this.jobNumber,
    required this.orderedQuantity,
    required this.incomingQuantity,
    required this.status,
    required this.eliquidDescription,
    required this.createdAt,
  });

  factory RepatJobSummaryDto.fromJson(Map<String, dynamic> json) {
    final productionOrderJson = json['productionOrder'] as Map<String, dynamic>;

    return RepatJobSummaryDto(
      id: json['id'] as String,
      jobNumber: json['jobNumber'] as String,
      orderedQuantity: json['repatOrderedQuantity'] as int,
      incomingQuantity: json['producedQuantity'] as int,
      status: RepatJobStatusDto.fromString(json['status'] as String),
      eliquidDescription:
          productionOrderJson['eliquid']['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

enum RepatJobStatusDto {
  cancelled,
  completed,
  inProgress,
  reassigned;

  static RepatJobStatusDto fromString(String value) {
    return switch (value) {
      'CANCELLED' => RepatJobStatusDto.cancelled,
      'DELIVERED' => RepatJobStatusDto.completed,
      'FULFILLED' => RepatJobStatusDto.inProgress,
      'PENDING' => RepatJobStatusDto.reassigned,
      _ => throw FormatException('Unknown RepatJobStatus: $value'),
    };
  }
}
