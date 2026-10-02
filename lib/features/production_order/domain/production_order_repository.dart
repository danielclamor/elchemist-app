import 'package:elchemist_app/features/production_order/domain/production_order_list_page.dart';

import 'production_order.dart';

abstract class ProductionOrderRepository {
  Future<ProductionOrderListPage> getListPage({
    required int first,
    String? after,
  });

  Stream<ProductionOrderListPage> watchListPage({
    required int first,
    String? after,
  });

  Future<ProductionOrder?> getDetails({required String id});
}
