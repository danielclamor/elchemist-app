import 'package:elchemist_app/features/production_order/domain/production_order.dart';

class ProductionOrderListPage {
  final List<ProductionOrderSummary> items;
  final String? endCursor;
  final bool hasNextPage;

  const ProductionOrderListPage({
    required this.items,
    required this.endCursor,
    required this.hasNextPage,
  });
}
