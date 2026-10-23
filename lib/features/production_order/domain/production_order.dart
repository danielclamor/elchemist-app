import 'package:elchemist_app/features/eliquid/domain/eliquid.dart';
import 'package:elchemist_app/features/production_order/data/production_order_dto.dart';
import 'package:elchemist_app/features/production_order/domain/production_order_activity_log.dart';
import 'package:elchemist_app/features/production_order/domain/production_order_allocation.dart';

class ProductionOrder {
  final String id;
  final String orderNumber;
  final ProductionOrderStatus status;
  final DateTime createdAt;
  final int? orderedQuantity;
  final int? fulfilledQuantity;
  final bool isPriority;
  final ProductionOrderJobType? jobType;
  final List<ProductionOrderAllocation> allocations;
  final EliquidSummary eliquid;
  final List<ProductionOrderActivityLog> activityLogs;
  final bool isOpen;

  ProductionOrder({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.createdAt,
    required this.orderedQuantity,
    required this.fulfilledQuantity,
    required this.isPriority,
    required this.jobType,
    required this.allocations,
    required this.eliquid,
    required this.activityLogs,
    required this.isOpen,
  });

  factory ProductionOrder.fromDto(ProductionOrderDto o) {
    return ProductionOrder(
      id: o.id,
      orderNumber: o.orderNumber,
      createdAt: o.createdAt,
      status: ProductionOrderStatus.fromDto(o.status),
      orderedQuantity: o.orderedQuantity,
      fulfilledQuantity: o.fulfilledQuantity,
      isPriority: o.isPriority,
      jobType: ProductionOrderJobType.fromDto(o.jobType),
      allocations: o.allocations
          .map((a) => ProductionOrderAllocation.fromDto(a))
          .toList(),
      eliquid: EliquidSummary.fromDto(o.eliquid),
      activityLogs: o.activityLogs
          .map((l) => ProductionOrderActivityLog.fromDto(l))
          .toList(),
      isOpen: o.isOpen,
    );
  }
}

class ProductionOrderSummary {
  final String id;
  final String orderNumber;
  final ProductionOrderStatus status;
  final DateTime createdAt;
  final int? orderedQuantity;
  final int? fulfilledQuantity;
  final bool isPriority;
  final ProductionOrderJobType? jobType;
  final String eliquidDescription;

  const ProductionOrderSummary({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.createdAt,
    required this.orderedQuantity,
    required this.fulfilledQuantity,
    required this.isPriority,
    this.jobType,
    required this.eliquidDescription,
  });

  factory ProductionOrderSummary.fromDto(ProductionOrderSummaryDto o) {
    return ProductionOrderSummary(
      id: o.id,
      orderNumber: o.orderNumber,
      createdAt: o.createdAt,
      status: ProductionOrderStatus.fromDto(o.status),
      orderedQuantity: o.orderedQuantity,
      fulfilledQuantity: o.fulfilledQuantity,
      isPriority: o.isPriority,
      jobType: ProductionOrderJobType.fromDto(o.jobType),
      eliquidDescription: o.eliquidDescription,
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}

enum ProductionOrderStatus {
  cancelled,
  delivered,
  fulfilled,
  inProgress,
  pending;

  @override
  String toString() {
    return switch (this) {
      ProductionOrderStatus.cancelled => 'Cancelled',
      ProductionOrderStatus.delivered => 'Delivered',
      ProductionOrderStatus.fulfilled => 'Fulfilled',
      ProductionOrderStatus.inProgress => 'In progress',
      ProductionOrderStatus.pending => 'Pending',
    };
  }

  static ProductionOrderStatus fromDto(ProductionOrderStatusDto s) {
    return switch (s) {
      ProductionOrderStatusDto.cancelled => ProductionOrderStatus.cancelled,
      ProductionOrderStatusDto.delivered => ProductionOrderStatus.delivered,
      ProductionOrderStatusDto.fulfilled => ProductionOrderStatus.fulfilled,
      ProductionOrderStatusDto.inProgress => ProductionOrderStatus.inProgress,
      ProductionOrderStatusDto.pending => ProductionOrderStatus.pending,
    };
  }
}

enum ProductionOrderJobType {
  mix,
  repat;

  @override
  String toString() {
    return switch (this) {
      ProductionOrderJobType.mix => 'Mix',
      ProductionOrderJobType.repat => 'Streamline',
    };
  }

  static ProductionOrderJobType? fromDto(ProductionOrderJobTypeDto? j) {
    return switch (j) {
      ProductionOrderJobTypeDto.mix => ProductionOrderJobType.mix,
      ProductionOrderJobTypeDto.repat => ProductionOrderJobType.repat,
      null => null,
    };
  }
}
