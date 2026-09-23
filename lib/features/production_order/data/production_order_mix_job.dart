class ProductionOrderMixJobDto {
  final String id;
  final String status;
  final int orderedQuantity;
  final int producedQuantity;
  final String batchNumber;
  final Map recipeSnapshot;
  final double totalVolumeMl;
  final double totalWeightG;
  final DateTime createdAt;
  final Map<String, dynamic>? productionOrder;

  const ProductionOrderMixJobDto({
    required this.id,
    required this.status,
    required this.orderedQuantity,
    required this.producedQuantity,
    required this.batchNumber,
    required this.recipeSnapshot,
    required this.totalVolumeMl,
    required this.totalWeightG,
    required this.createdAt,
    this.productionOrder,
  });

  factory ProductionOrderMixJobDto.fromJson(Map<String, dynamic> json) {
    return ProductionOrderMixJobDto(
      id: json['id'] as String,
      status: json['status'] as String,
      orderedQuantity: json['orderedQuantity'] as int,
      producedQuantity: json['producedQuantity'] as int,
      batchNumber: json['batchNumber'] as String,
      recipeSnapshot: json['recipeSnapshot'] as Map,
      totalVolumeMl: _toDouble(['totalVolumeMl']),
      totalWeightG: _toDouble(json['totalWeightG']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      productionOrder: json['productionOrder'] as Map<String, dynamic>,
    );
  }

  static double _toDouble(Object? v) => (v as num).toDouble();
}
