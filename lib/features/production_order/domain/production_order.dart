import 'package:elchemist_app/features/production_order/data/production_order_dto.dart';

enum ProductionOrderStatus {
  cancelled,
  delivered,
  fulfilled,
  inProgress,
  pending;

  @override
  String toString() {
    switch (this) {
      case ProductionOrderStatus.cancelled:
        return 'Cancelled';
      case ProductionOrderStatus.delivered:
        return 'Delivered';
      case ProductionOrderStatus.fulfilled:
        return 'Fulfilled';
      case ProductionOrderStatus.inProgress:
        return 'In progress';
      case ProductionOrderStatus.pending:
        return 'Pending';
    }
  }

  static ProductionOrderStatus fromString(String value) {
    switch (value) {
      case 'CANCELLED':
        return ProductionOrderStatus.cancelled;
      case 'DELIVERED':
        return ProductionOrderStatus.delivered;
      case 'FULFILLED':
        return ProductionOrderStatus.fulfilled;
      case 'IN_PROGRESS':
        return ProductionOrderStatus.inProgress;
      case 'PENDING':
        return ProductionOrderStatus.pending;
      default:
        throw ArgumentError('Unknown ProductionOrderStatus: $value');
    }
  }
}

enum ProductionOrderJob {
  mix,
  repat;

  @override
  String toString() {
    switch (this) {
      case ProductionOrderJob.mix:
        return 'Mix';
      case ProductionOrderJob.repat:
        return 'Repat';
    }
  }

  static ProductionOrderJob fromString(String value) {
    switch (value) {
      case 'MIX':
        return ProductionOrderJob.mix;
      case 'REPAT':
        return ProductionOrderJob.repat;
      default:
        throw ArgumentError('Unknown ProductionOrderJob: $value');
    }
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
      createdAt: DateTime.parse(o.createdAt),
      status: ProductionOrderStatus.fromString(o.status),
      orderedQuantity: o.orderedQuantity,
      fulfilledQuantity: o.fulfilledQuantity,
      isPriority: o.isPriority,
      job: job != null ? ProductionOrderJob.fromString(job) : null,
      eliquidDescription: o.eliquidDescription,
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
