import 'package:elchemist_app/features/nic_base_option/domain/nic_base_option_list_page.dart';

abstract class NicBaseOptionRepository {
  Future<NicBaseOptionListPage> getListPage({
    required int first,
    String? after,
  });
}
