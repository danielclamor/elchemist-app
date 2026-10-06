import 'package:elchemist_app/features/eliquid/domain/eliquid.dart';

class EliquidListPage {
  final List<EliquidSummary> items;
  final String? endCursor;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const EliquidListPage({
    required this.items,
    required this.endCursor,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });
}
