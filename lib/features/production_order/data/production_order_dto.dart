import 'package:elchemist_app/features/eliquid/data/eliquid_dto.dart';
import 'package:elchemist_app/features/production_order/data/production_order_activity_log_dto.dart';
import 'package:elchemist_app/features/production_order/data/production_order_allocation_dto.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';

class ProductionOrderSummaryDto {
  final String id;
  final String orderNumber;
  final int? orderedQuantity;
  final int? fulfilledQuantity;
  final DateTime createdAt;
  final ProductionOrderStatusDto status;
  final bool isPriority;
  final ProductionOrderJobTypeDto? jobType;
  final String eliquidDescription;

  const ProductionOrderSummaryDto({
    required this.id,
    required this.orderNumber,
    required this.orderedQuantity,
    required this.fulfilledQuantity,
    required this.createdAt,
    required this.status,
    required this.isPriority,
    required this.jobType,
    required this.eliquidDescription,
  });

  factory ProductionOrderSummaryDto.fromJson(Map<String, dynamic> json) {
    return ProductionOrderSummaryDto(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      status: ProductionOrderStatusDto.fromString(json['status'] as String),
      orderedQuantity: json['orderedQuantity'] as int?,
      fulfilledQuantity: json['fulfilledQuantity'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isPriority: json['isPriority'] as bool,
      jobType: ProductionOrderJobTypeDto.fromString(json['jobType'] as String?),
      eliquidDescription: json['eliquid']['description'] as String,
    );
  }
}

class ProductionOrderDto {
  final String id;
  final String orderNumber;
  final int? orderedQuantity;
  final int? fulfilledQuantity;
  final bool isPriority;
  final ProductionOrderStatusDto status;
  final ProductionOrderJobTypeDto? jobType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EliquidSummaryDto eliquid;
  final List<ProductionOrderActivityLogDto> activityLogs;
  final List<ProductionOrderAllocationDto> allocations;
  final String? currentJobId;

  const ProductionOrderDto({
    required this.id,
    required this.orderNumber,
    required this.orderedQuantity,
    required this.fulfilledQuantity,
    required this.isPriority,
    required this.status,
    required this.jobType,
    required this.createdAt,
    required this.updatedAt,
    required this.eliquid,
    required this.activityLogs,
    required this.allocations,
    required this.currentJobId,
  });

  factory ProductionOrderDto.fromJson(Map<String, dynamic> json) {
    final activityLogsJson = json['activityLogs'] as List<dynamic>;

    final allocationsJson = json['allocations'] as List<dynamic>;

    final currentJobJson = json['currentJob'] as Map<String, dynamic>?;

    return ProductionOrderDto(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      orderedQuantity: json['orderedQuantity'] as int?,
      fulfilledQuantity: json['fulfilledQuantity'] as int?,
      isPriority: json['isPriority'] as bool,
      status: ProductionOrderStatusDto.fromString(json['status'] as String),
      jobType: ProductionOrderJobTypeDto.fromString(json['jobType'] as String?),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      eliquid:
          EliquidSummaryDto.fromJson(json['eliquid'] as Map<String, dynamic>),
      activityLogs: activityLogsJson
          .map((l) => ProductionOrderActivityLogDto.fromJson(
              Map<String, dynamic>.from(l as Map)))
          .toList(),
      allocations: allocationsJson
          .map((a) => ProductionOrderAllocationDto.fromJson(
              Map<String, dynamic>.from(a as Map)))
          .toList(),
      currentJobId:
          currentJobJson != null ? currentJobJson['id'] as String : null,
    );
  }
}

enum ProductionOrderStatusDto {
  cancelled,
  delivered,
  fulfilled,
  inProgress,
  pending;

  static ProductionOrderStatusDto fromString(String value) {
    return switch (value) {
      'CANCELLED' => ProductionOrderStatusDto.cancelled,
      'DELIVERED' => ProductionOrderStatusDto.delivered,
      'FULFILLED' => ProductionOrderStatusDto.fulfilled,
      'IN_PROGRESS' => ProductionOrderStatusDto.inProgress,
      'PENDING' => ProductionOrderStatusDto.pending,
      _ => throw FormatException('Unknown ProductionOrderStatus: $value'),
    };
  }
}

extension ProductionOrderStatusGraphQl on ProductionOrderStatus {
  String get gql => switch (this) {
        ProductionOrderStatus.pending => 'PENDING',
        ProductionOrderStatus.inProgress => 'IN_PROGRESS',
        ProductionOrderStatus.fulfilled => 'FULFILLED',
        ProductionOrderStatus.delivered => 'DELIVERED',
        ProductionOrderStatus.cancelled => 'CANCELLED',
      };
}

enum ProductionOrderJobTypeDto {
  mix,
  repat;

  static ProductionOrderJobTypeDto? fromString(String? value) {
    return switch (value) {
      'MIX' => ProductionOrderJobTypeDto.mix,
      'REPAT' => ProductionOrderJobTypeDto.repat,
      null => null,
      _ => throw FormatException('Unknown ProductionOrderJob: $value'),
    };
  }
}
