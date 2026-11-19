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
  final bool isCanceled;
  final bool isArchived;
  final List<ProductionOrderAllocation> allocations;
  final EliquidSummary eliquid;
  final List<ProductionOrderActivityLog> activityLogs;
  final String? mixSessionId;
  final String? mixSessionMixNumber;

  ProductionOrder({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.createdAt,
    required this.orderedQuantity,
    required this.fulfilledQuantity,
    required this.isPriority,
    required this.allocations,
    required this.eliquid,
    required this.activityLogs,
    required this.mixSessionId,
    required this.mixSessionMixNumber,
    required this.isCanceled,
    required this.isArchived,
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
      allocations: o.allocations
          .map((a) => ProductionOrderAllocation.fromDto(a))
          .toList(),
      eliquid: EliquidSummary.fromDto(o.eliquid),
      activityLogs: o.activityLogs
          .map((l) => ProductionOrderActivityLog.fromDto(l))
          .toList(),
      mixSessionId: o.mixSessionId,
      mixSessionMixNumber: o.mixSessionMixNumber,
      isCanceled: o.isCanceled,
      isArchived: o.isArchived,
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
  final bool isCanceled;
  final bool isArchived;
  final BottleSize eliquidBottleSize;
  final String eliquidDescription;
  final String? formulaId;
  final bool? formulaIsPreMix;
  final String? mixSessionMixNumber;

  const ProductionOrderSummary({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.createdAt,
    required this.orderedQuantity,
    required this.fulfilledQuantity,
    required this.isPriority,
    required this.eliquidBottleSize,
    required this.eliquidDescription,
    required this.formulaId,
    required this.formulaIsPreMix,
    required this.mixSessionMixNumber,
    required this.isCanceled,
    required this.isArchived,
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
      eliquidBottleSize: BottleSize.fromDto(o.eliquidBottleSize),
      eliquidDescription: o.eliquidDescription,
      formulaId: o.formulaId,
      formulaIsPreMix: o.formulaIsPreMix,
      mixSessionMixNumber: o.mixSessionMixNumber,
      isCanceled: o.isCanceled,
      isArchived: o.isArchived,
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}

enum ProductionOrderStatus {
  fulfilled,
  inProgress,
  pending,
  mixed,
  pumped;

  @override
  String toString() {
    return switch (this) {
      ProductionOrderStatus.fulfilled => 'Fulfilled',
      ProductionOrderStatus.inProgress => 'In progress',
      ProductionOrderStatus.pending => 'Pending',
      ProductionOrderStatus.mixed => 'Mixed',
      ProductionOrderStatus.pumped => 'Pumped',
    };
  }

  static ProductionOrderStatus fromDto(ProductionOrderStatusDto s) {
    return switch (s) {
      ProductionOrderStatusDto.fulfilled => ProductionOrderStatus.fulfilled,
      ProductionOrderStatusDto.inProgress => ProductionOrderStatus.inProgress,
      ProductionOrderStatusDto.pending => ProductionOrderStatus.pending,
      ProductionOrderStatusDto.mixed => ProductionOrderStatus.mixed,
      ProductionOrderStatusDto.pumped => ProductionOrderStatus.pumped,
    };
  }
}
