class ProductionOrderRepatJobDto {
  final String id;
  final String status;
  final int orderedQuantity;
  final int incomingQuantity;
  final DateTime createdAt;
  final Map<String, dynamic>? productionOrder;

  const ProductionOrderRepatJobDto({
    required this.id,
    required this.status,
    required this.orderedQuantity,
    required this.incomingQuantity,
    required this.createdAt,
    this.productionOrder,
  });

  factory ProductionOrderRepatJobDto.fromJson(Map<String, dynamic> json) {
    return ProductionOrderRepatJobDto(
      id: json['id'] as String,
      status: json['status'] as String,
      orderedQuantity: json['orderedQuantity'] as int,
      incomingQuantity: json['producedQuantity'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      productionOrder: json['productionOrder'] as Map<String, dynamic>,
    );
  }
}
