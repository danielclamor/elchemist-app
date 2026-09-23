class ProductionOrderActivityLogDto {
  final String id;
  final String activity;
  final String? oldValue;
  final String? newValue;
  final DateTime triggeredAt;

  const ProductionOrderActivityLogDto({
    required this.id,
    required this.activity,
    this.oldValue,
    this.newValue,
    required this.triggeredAt,
  });

  factory ProductionOrderActivityLogDto.fromJson(Map<String, dynamic> json) {
    return ProductionOrderActivityLogDto(
      id: json['id'] as String,
      activity: json['activity'] as String,
      oldValue: json['oldValue'] as String?,
      newValue: json['newValue'] as String?,
      triggeredAt: DateTime.parse(json['triggeredAt'] as String),
    );
  }
}
