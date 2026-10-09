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
  final ProductionOrderJob? job;
  final List<ProductionOrderAllocation> allocations;
  final EliquidSummary eliquid;
  final List<ProductionOrderActivityLog> activityLogs;

  ProductionOrder({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.createdAt,
    required this.orderedQuantity,
    required this.fulfilledQuantity,
    required this.isPriority,
    required this.job,
    required this.allocations,
    required this.eliquid,
    required this.activityLogs,
  });

  factory ProductionOrder.fromDto(ProductionOrderDto o) {
    final job = o.job;

    return ProductionOrder(
      id: o.id,
      orderNumber: o.orderNumber,
      createdAt: o.createdAt,
      status: ProductionOrderStatus.fromDto(o.status),
      orderedQuantity: o.orderedQuantity,
      fulfilledQuantity: o.fulfilledQuantity,
      isPriority: o.isPriority,
      job: ProductionOrderJob.fromDto(job),
      allocations: o.allocations
          .map((a) => ProductionOrderAllocation.fromDto(a))
          .toList(),
      eliquid: EliquidSummary.fromDto(o.eliquid),
      activityLogs: o.activityLogs
          .map((l) => ProductionOrderActivityLog.fromDto(l))
          .toList(),
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
  final ProductionOrderJob? job;
  final String eliquidDescription;

  const ProductionOrderSummary({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.createdAt,
    required this.orderedQuantity,
    required this.fulfilledQuantity,
    required this.isPriority,
    this.job,
    required this.eliquidDescription,
  });

  factory ProductionOrderSummary.fromDto(ProductionOrderSummaryDto o) {
    final job = o.job;

    return ProductionOrderSummary(
      id: o.id,
      orderNumber: o.orderNumber,
      createdAt: o.createdAt,
      status: ProductionOrderStatus.fromDto(o.status),
      orderedQuantity: o.orderedQuantity,
      fulfilledQuantity: o.fulfilledQuantity,
      isPriority: o.isPriority,
      job: ProductionOrderJob.fromDto(job),
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

enum ProductionOrderJob {
  mix,
  repat;

  @override
  String toString() {
    return switch (this) {
      ProductionOrderJob.mix => 'Mix',
      ProductionOrderJob.repat => 'Repat',
    };
  }

  static ProductionOrderJob? fromDto(ProductionOrderJobDto? j) {
    return switch (j) {
      ProductionOrderJobDto.mix => ProductionOrderJob.mix,
      ProductionOrderJobDto.repat => ProductionOrderJob.repat,
      null => null,
    };
  }
}
