import 'package:elchemist_app/features/mix_batch/domain/mix_batch.dart';

class MixBatchListPage {
  final List<MixBatchSummary> items;
  final String? endCursor;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final int totalCount;

  const MixBatchListPage({
    required this.items,
    required this.endCursor,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.totalCount,
  });
}
