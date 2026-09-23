import 'package:elchemist_app/features/production_order/data/production_order_activity_log_dto.dart';
import 'package:elchemist_app/features/production_order/data/production_order_mix_job.dart';
import 'package:elchemist_app/features/production_order/data/production_order_repat_job.dart';

class ProductionOrderSummaryDto {
  final String id;
  final String orderNumber;
  final int? orderedQuantity;
  final int? fulfilledQuantity;
  final String createdAt;
  final String status;
  final bool isPriority;
  final String? job;
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
      status: json['status'] as String,
      orderedQuantity: json['orderedQuantity'] as int?,
      fulfilledQuantity: json['fulfilledQuantity'] as int?,
      createdAt: json['createdAt'] as String,
      isPriority: json['isPriority'] as bool,
      job: json['job'] as String,
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
  final String status;
  final String? job;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> eliquid;
  final List<ProductionOrderActivityLogDto>? activityLogs;
  final List<ProductionOrderMixJobDto>? mixJobs;
  final List<ProductionOrderRepatJobDto>? repatJobs;

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
    this.activityLogs,
    this.mixJobs,
    this.repatJobs,
  });

  factory ProductionOrderDto.fromJson(Map<String, dynamic> json) {
    final activityLogsJson = json['activityLogs'] as Map<String, dynamic>?;
    final activityLogEdges = activityLogsJson?['edges'] as List<dynamic>?;

    final mixJobsJson = json['productionOrderMixJobs'] as Map<String, dynamic>?;
    final mixJobEdges = mixJobsJson?['edges'] as List<dynamic>?;

    final repatJobsJson =
        json['productionOrderRepatJobs'] as Map<String, dynamic>?;
    final repatJobEdges = repatJobsJson?['edges'] as List<dynamic>?;

    return ProductionOrderDto(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      orderedQuantity: json['orderedQuantity'] as int?,
      fulfilledQuantity: json['fulfilledQuantity'] as int?,
      isPriority: json['isPriority'] as bool,
      status: json['status'] as String,
      job: json['job'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      eliquid: json['eliquid'] as Map<String, dynamic>,
      activityLogs: activityLogEdges
          ?.map(
            (e) => ProductionOrderActivityLogDto.fromJson(
              (e as Map<String, dynamic>)['node'] as Map<String, dynamic>,
            ),
          )
          .toList(),
      mixJobs: mixJobEdges
          ?.map(
            (e) => ProductionOrderMixJobDto.fromJson(
              (e as Map<String, dynamic>)['node'] as Map<String, dynamic>,
            ),
          )
          .toList(),
      repatJobs: repatJobEdges
          ?.map(
            (e) => ProductionOrderRepatJobDto.fromJson(
              (e as Map<String, dynamic>)['node'] as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}
