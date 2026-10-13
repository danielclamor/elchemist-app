import 'package:elchemist_app/features/location/domain/location.dart';

class LocationListPage {
  final List<LocationSummary> items;
  final String? endCursor;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const LocationListPage({
    required this.items,
    required this.endCursor,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  LocationListPage append(LocationListPage next) => LocationListPage(
        items: [...items, ...next.items],
        endCursor: next.endCursor,
        hasPreviousPage: hasPreviousPage,
        hasNextPage: next.hasNextPage,
      );
}
