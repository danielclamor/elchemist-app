class ProductionOrderActivityLogDto {
  final String id;
  final ProductionOrderActivityTypeDto type;
  final String? oldValue;
  final String? newValue;
  final DateTime triggeredAt;

  const ProductionOrderActivityLogDto({
    required this.id,
    required this.type,
    this.oldValue,
    this.newValue,
    required this.triggeredAt,
  });

  factory ProductionOrderActivityLogDto.fromJson(Map<String, dynamic> json) {
    return ProductionOrderActivityLogDto(
      id: json['id'] as String,
      type: ProductionOrderActivityTypeDto.fromString(json['type'] as String),
      oldValue: json['oldValue'] as String?,
      newValue: json['newValue'] as String?,
      triggeredAt: DateTime.parse(json['triggeredAt'] as String),
    );
  }
}

enum ProductionOrderActivityTypeDto {
  created,
  adjustQuantity,
  changeStatus,
  switchPriority,
  toggleArchived,
  assignJob;

  static ProductionOrderActivityTypeDto fromString(String value) {
    return switch (value) {
      'CREATED' => ProductionOrderActivityTypeDto.created,
      'ADJUST_QUANTITY' => ProductionOrderActivityTypeDto.adjustQuantity,
      'CHANGE_STATUS' => ProductionOrderActivityTypeDto.changeStatus,
      'SWITCH_PRIORITY' => ProductionOrderActivityTypeDto.switchPriority,
      'TOGGLE_ARCHIVED' => ProductionOrderActivityTypeDto.toggleArchived,
      'ASSIGN_JOB' => ProductionOrderActivityTypeDto.assignJob,
      _ => throw FormatException('Unknown ProductionOrderActivityType: $value')
    };
  }
}
