import 'package:elchemist_app/features/location/data/location_dto.dart';

class ProductionOrderAllocationDto {
  final String id;
  final LocationSummaryDto location;
  final int quantity;

  const ProductionOrderAllocationDto({
    required this.id,
    required this.location,
    required this.quantity,
  });

  factory ProductionOrderAllocationDto.fromJson(Map<String, dynamic> json) {
    return ProductionOrderAllocationDto(
      id: json['id'],
      location: LocationSummaryDto.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      quantity: json['quantity'],
    );
  }
}
