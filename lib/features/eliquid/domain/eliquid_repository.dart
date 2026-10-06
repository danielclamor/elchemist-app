import 'package:elchemist_app/features/eliquid/domain/eliquid_list_page.dart';

abstract class EliquidRepository {
  Future<EliquidListPage> getListPage({
    required int first,
    String? after,
  });
}
