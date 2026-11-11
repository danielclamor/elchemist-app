import 'package:elchemist_app/features/mix_session/domain/mix_session.dart';

class MixSessionListPage {
  final List<MixSessionSummary> items;
  final String? endCursor;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final int totalCount;

  const MixSessionListPage({
    required this.items,
    required this.endCursor,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.totalCount,
  });
}
