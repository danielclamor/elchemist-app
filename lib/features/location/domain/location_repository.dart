import 'package:elchemist_app/features/location/domain/location_list_page.dart';

abstract class LocationRepository {
  Future<LocationListPage> getListPage({
    required int first,
    String? after,
  });
}
