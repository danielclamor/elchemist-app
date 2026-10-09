import 'package:elchemist_app/features/production_order/data/production_order_activity_log_dto.dart';

class ProductionOrderActivityLog {
  final String id;
  final ProductionOrderActivityType type;
  final String? oldValue;
  final String? newValue;
  final DateTime triggeredAt;

  const ProductionOrderActivityLog({
    required this.id,
    required this.type,
    required this.oldValue,
    required this.newValue,
    required this.triggeredAt,
  });

  factory ProductionOrderActivityLog.fromDto(ProductionOrderActivityLogDto l) {
    return ProductionOrderActivityLog(
      id: l.id,
      type: ProductionOrderActivityType.fromDto(l.type),
      oldValue: l.oldValue,
      newValue: l.newValue,
      triggeredAt: l.triggeredAt,
    );
  }
}

enum ProductionOrderActivityType {
  created,
  adjustQuantity,
  changeStatus,
  switchPriority,
  toggleArchived,
  assignJob;

  @override
  String toString() {
    return switch (this) {
      ProductionOrderActivityType.created => 'Created',
      ProductionOrderActivityType.adjustQuantity => 'Adjust quantity',
      ProductionOrderActivityType.changeStatus => 'Change status',
      ProductionOrderActivityType.switchPriority => 'Switch priority',
      ProductionOrderActivityType.toggleArchived => 'Toggle archived',
      ProductionOrderActivityType.assignJob => 'Assign job',
    };
  }

  static ProductionOrderActivityType fromDto(ProductionOrderActivityTypeDto t) {
    return switch (t) {
      ProductionOrderActivityTypeDto.created =>
        ProductionOrderActivityType.created,
      ProductionOrderActivityTypeDto.adjustQuantity =>
        ProductionOrderActivityType.adjustQuantity,
      ProductionOrderActivityTypeDto.changeStatus =>
        ProductionOrderActivityType.changeStatus,
      ProductionOrderActivityTypeDto.switchPriority =>
        ProductionOrderActivityType.switchPriority,
      ProductionOrderActivityTypeDto.toggleArchived =>
        ProductionOrderActivityType.toggleArchived,
      ProductionOrderActivityTypeDto.assignJob =>
        ProductionOrderActivityType.assignJob,
    };
  }
}
