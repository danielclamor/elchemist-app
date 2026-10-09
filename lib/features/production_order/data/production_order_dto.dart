import 'package:elchemist_app/features/eliquid/data/eliquid_dto.dart';
import 'package:elchemist_app/features/production_order/data/production_order_activity_log_dto.dart';
import 'package:elchemist_app/features/production_order/data/production_order_allocation_dto.dart';
import 'package:elchemist_app/features/production_order/data/production_order_mix_job.dart';
import 'package:elchemist_app/features/production_order/data/production_order_repat_job.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';

class ProductionOrderSummaryDto {
  final String id;
  final String orderNumber;
  final int? orderedQuantity;
  final int? fulfilledQuantity;
  final DateTime createdAt;
  final ProductionOrderStatusDto status;
  final bool isPriority;
  final ProductionOrderJobDto? job;
  final String eliquidDescription;

  const ProductionOrderSummaryDto({
    required this.id,
    required this.orderNumber,
    required this.orderedQuantity,
    required this.fulfilledQuantity,
    required this.createdAt,
    required this.status,
    required this.isPriority,
    required this.job,
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
      job: json['job'] != null
          ? ProductionOrderJobDto.fromString(json['job'] as String)
          : null,
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
  final ProductionOrderJobDto? job;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EliquidSummaryDto eliquid;
  final List<ProductionOrderActivityLogDto> activityLogs;
  // final List<ProductionOrderMixJobDto>? mixJobs;
  // final List<ProductionOrderRepatJobDto>? repatJobs;
  final List<ProductionOrderAllocationDto> allocations;

  const ProductionOrderDto({
    required this.id,
    required this.orderNumber,
    required this.orderedQuantity,
    required this.fulfilledQuantity,
    required this.isPriority,
    required this.status,
    required this.job,
    required this.createdAt,
    required this.updatedAt,
    required this.eliquid,
    required this.activityLogs,
    // this.mixJobs,
    // this.repatJobs,
    required this.allocations,
  });

  factory ProductionOrderDto.fromJson(Map<String, dynamic> json) {
    final activityLogsJson = json['activityLogs'] as List<dynamic>;

    // final mixJobsJson = json['productionOrderMixJobs'] as Map<String, dynamic>?;
    // final mixJobEdges = mixJobsJson?['edges'] as List<dynamic>?;

    // final repatJobsJson =
    //     json['productionOrderRepatJobs'] as Map<String, dynamic>?;
    // final repatJobEdges = repatJobsJson?['edges'] as List<dynamic>?;

    final allocationsJson = json['allocations'] as List<dynamic>;

    return ProductionOrderDto(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      orderedQuantity: json['orderedQuantity'] as int?,
      fulfilledQuantity: json['fulfilledQuantity'] as int?,
      isPriority: json['isPriority'] as bool,
      status: ProductionOrderStatusDto.fromString(json['status'] as String),
      job: ProductionOrderJobDto.fromString(json['job'] as String?),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      eliquid:
          EliquidSummaryDto.fromJson(json['eliquid'] as Map<String, dynamic>),
      activityLogs: activityLogsJson
          .map((l) => ProductionOrderActivityLogDto.fromJson(
              Map<String, dynamic>.from(l as Map)))
          .toList(),
      // mixJobs: mixJobEdges
      //     ?.map((e) => ProductionOrderMixJobDto.fromJson(
      //         (e as Map<String, dynamic>)['node'] as Map<String, dynamic>))
      //     .toList(),
      // repatJobs: repatJobEdges
      //     ?.map((e) => ProductionOrderRepatJobDto.fromJson(
      //         (e as Map<String, dynamic>)['node'] as Map<String, dynamic>))
      //     .toList(),
      allocations: allocationsJson
          .map((a) => ProductionOrderAllocationDto.fromJson(
              Map<String, dynamic>.from(a as Map)))
          .toList(),
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

enum ProductionOrderJobDto {
  mix,
  repat;

  static ProductionOrderJobDto? fromString(String? value) {
    return switch (value) {
      'MIX' => ProductionOrderJobDto.mix,
      'REPAT' => ProductionOrderJobDto.repat,
      null => null,
      _ => throw FormatException('Unknown ProductionOrderJob: $value'),
    };
  }
}
