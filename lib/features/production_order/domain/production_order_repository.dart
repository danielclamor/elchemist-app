import 'package:elchemist_app/features/production_order/domain/production_order_date_range.dart';
import 'package:elchemist_app/features/production_order/domain/production_order_list_page.dart';

import 'production_order.dart';

abstract class ProductionOrderRepository {
  Future<ProductionOrderListPage> getListPage({
    required int first,
    String? after,
    ProductionOrderStatus? status,
    DateRange? range,
  });

  Stream<ProductionOrderListPage> watchListPage({
    required int first,
    String? after,
    ProductionOrderStatus? status,
    DateRange? range,
  });

  Stream<Map<ProductionOrderStatus, int>> watchStatusCounts({
    DateRange? range,
  });

  Future<ProductionOrder?> getDetails({required String id});

  Future<ProductionOrderListPage> getEliquidPastOrdersPage({
    required String eliquidId,
    required int first,
    String? after,
  });
}
