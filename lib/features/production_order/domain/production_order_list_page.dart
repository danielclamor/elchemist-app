import 'package:elchemist_app/features/production_order/domain/production_order.dart';

class ProductionOrderListPage {
  final List<ProductionOrderSummary> items;
  final String? endCursor;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final int totalCount;

  const ProductionOrderListPage({
    required this.items,
    required this.endCursor,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.totalCount,
  });
}
