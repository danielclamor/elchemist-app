import 'package:elchemist_app/features/nic_base_option/domain/nic_base_option.dart';

class NicBaseOptionListPage {
  final List<NicBaseOption> items;
  final String? endCursor;
  final bool hasPreviousPage;
  final bool hasNextPage;
  // final int totalCount;

  const NicBaseOptionListPage({
    required this.items,
    required this.endCursor,
    required this.hasPreviousPage,
    required this.hasNextPage,
    // required this.totalCount,
  });

  NicBaseOptionListPage append(NicBaseOptionListPage next) =>
      NicBaseOptionListPage(
        items: [...items, ...next.items],
        endCursor: next.endCursor,
        hasPreviousPage: next.hasPreviousPage,
        hasNextPage: hasNextPage,
        // totalCount: next.totalCount,
      );
}
