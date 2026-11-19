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
  final bool isCanceled;
  final bool isArchived;
  final BottleSizeDto eliquidBottleSize;
  final String eliquidDescription;
  final String? formulaId;
  final bool? formulaIsPreMix;
  final String? mixSessionMixNumber;

  const ProductionOrderSummaryDto({
    required this.id,
    required this.orderNumber,
    required this.orderedQuantity,
    required this.fulfilledQuantity,
    required this.createdAt,
    required this.status,
    required this.isPriority,
    required this.eliquidBottleSize,
    required this.eliquidDescription,
    required this.formulaId,
    required this.formulaIsPreMix,
    required this.mixSessionMixNumber,
    required this.isCanceled,
    required this.isArchived,
  });

  factory ProductionOrderSummaryDto.fromJson(Map<String, dynamic> json) {
    final formulaJson = json['eliquid']['formula'];
    final mixSessionJson = json['mixSession'] as Map<String, dynamic>?;

    return ProductionOrderSummaryDto(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      status: ProductionOrderStatusDto.fromString(json['status'] as String),
      orderedQuantity: json['orderedQuantity'] as int?,
      fulfilledQuantity: json['fulfilledQuantity'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isPriority: json['isPriority'] as bool,
      isCanceled: json['isCanceled'] as bool,
      isArchived: json['isArchived'] as bool,
      eliquidBottleSize:
          BottleSizeDto.fromString(json['eliquid']['bottleSize'] as String),
      eliquidDescription: json['eliquid']['description'] as String,
      formulaId: formulaJson != null ? formulaJson['id'] : null,
      formulaIsPreMix: formulaJson != null ? formulaJson['isPreMix'] : null,
      mixSessionMixNumber: mixSessionJson != null
          ? mixSessionJson['sessionNumber'] as String
          : null,
    );
  }
}

class ProductionOrderDto {
  final String id;
  final String orderNumber;
  final int? orderedQuantity;
  final int? fulfilledQuantity;
  final bool isPriority;
  final bool isCanceled;
  final bool isArchived;
  final ProductionOrderStatusDto status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EliquidSummaryDto eliquid;
  final List<ProductionOrderActivityLogDto> activityLogs;
  final List<ProductionOrderAllocationDto> allocations;
  final String? mixSessionId;
  final String? mixSessionMixNumber;

  const ProductionOrderDto({
    required this.id,
    required this.orderNumber,
    required this.orderedQuantity,
    required this.fulfilledQuantity,
    required this.isPriority,
    required this.isCanceled,
    required this.isArchived,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.eliquid,
    required this.activityLogs,
    required this.allocations,
    required this.mixSessionId,
    required this.mixSessionMixNumber,
  });

  factory ProductionOrderDto.fromJson(Map<String, dynamic> json) {
    final mixSessionJson = json['mixSession'] as Map<String, dynamic>?;

    final activityLogsJson = json['activityLogs'] as List<dynamic>;

    final allocationsJson = json['allocations'] as List<dynamic>;

    return ProductionOrderDto(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      orderedQuantity: json['orderedQuantity'] as int?,
      fulfilledQuantity: json['fulfilledQuantity'] as int?,
      isPriority: json['isPriority'] as bool,
      isCanceled: json['isCanceled'] as bool,
      isArchived: json['isArchived'] as bool,
      status: ProductionOrderStatusDto.fromString(json['status'] as String),
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
      mixSessionId:
          mixSessionJson != null ? mixSessionJson['id'] as String : null,
      mixSessionMixNumber: mixSessionJson != null
          ? mixSessionJson['sessionNumber'] as String
          : null,
    );
  }
}

enum ProductionOrderStatusDto {
  fulfilled,
  inProgress,
  pending,
  mixed,
  pumped;

  static ProductionOrderStatusDto fromString(String value) {
    return switch (value) {
      'FULFILLED' => ProductionOrderStatusDto.fulfilled,
      'IN_PROGRESS' => ProductionOrderStatusDto.inProgress,
      'PENDING' => ProductionOrderStatusDto.pending,
      'MIXED' => ProductionOrderStatusDto.mixed,
      'PUMPED' => ProductionOrderStatusDto.pumped,
      _ => throw FormatException('Unknown ProductionOrderStatus: $value'),
    };
  }
}

extension ProductionOrderStatusGraphQl on ProductionOrderStatus {
  String get gql => switch (this) {
        ProductionOrderStatus.pending => 'PENDING',
        ProductionOrderStatus.inProgress => 'IN_PROGRESS',
        ProductionOrderStatus.fulfilled => 'FULFILLED',
        ProductionOrderStatus.mixed => 'MIXED',
        ProductionOrderStatus.pumped => 'PUMPED',
      };
}
