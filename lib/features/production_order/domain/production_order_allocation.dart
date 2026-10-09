import 'package:elchemist_app/features/location/domain/location.dart';
import 'package:elchemist_app/features/production_order/data/production_order_allocation_dto.dart';

class ProductionOrderAllocation {
  final String id;
  final LocationSummary location;
  final int quantity;

  const ProductionOrderAllocation({
    required this.id,
    required this.location,
    required this.quantity,
  });

  factory ProductionOrderAllocation.fromDto(ProductionOrderAllocationDto a) {
    return ProductionOrderAllocation(
      id: a.id,
      location: LocationSummary.fromDto(a.location),
      quantity: a.quantity,
    );
  }
}
