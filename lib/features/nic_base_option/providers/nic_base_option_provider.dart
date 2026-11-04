import 'package:elchemist_app/core/graphql/graphql_client.dart';
import 'package:elchemist_app/features/nic_base_option/data/nic_base_option_repository.dart';
import 'package:elchemist_app/features/nic_base_option/domain/nic_base_option_list_page.dart';
import 'package:elchemist_app/features/nic_base_option/domain/nic_base_option_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nicBaseOptionRepositoryProvider = Provider<NicBaseOptionRepository>(
  (ref) => NicBaseOptionRepositoryImpl(ref.watch(graphQLClientProvider)),
);

const nicBaseOptionPageSize = 50;

typedef NicBasePageKey = ({
  String? after,
});

class NicBaseOptionInfiniteListState {
  final NicBaseOptionListPage page;
  final bool isLoadingMore;
  final Object? loadMoreError;

  const NicBaseOptionInfiniteListState({
    required this.page,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  NicBaseOptionInfiniteListState copyWith({
    NicBaseOptionListPage? page,
    bool? isLoadingMore,
    Object? loadMoreError,
    bool clearError = false,
  }) =>
      NicBaseOptionInfiniteListState(
        page: page ?? this.page,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        loadMoreError:
            clearError ? null : (loadMoreError ?? this.loadMoreError),
      );
}

class NicBaseOptionInfiniteList
    extends AsyncNotifier<NicBaseOptionInfiniteListState> {
  int _generation = 0;

  @override
  Future<NicBaseOptionInfiniteListState> build() async {
    _generation++;
    final page = await ref
        .watch(nicBaseOptionRepositoryProvider)
        .getListPage(first: nicBaseOptionPageSize);

    return NicBaseOptionInfiniteListState(page: page);
  }

  Future<void> loadMore({bool retry = false}) async {
    final current = state.value;
    if (current == null || !current.page.hasNextPage || current.isLoadingMore) {
      return;
    }
    if (current.loadMoreError != null && !retry) {
      return;
    }

    final token = _generation;
    state = AsyncData(
      current.copyWith(isLoadingMore: true, clearError: true),
    );

    try {
      final next = await ref.read(nicBaseOptionRepositoryProvider).getListPage(
            first: nicBaseOptionPageSize,
            after: current.page.endCursor,
          );
      if (!ref.mounted || token != _generation) return;

      state = AsyncData(current.copyWith(
        page: current.page.append(next),
        isLoadingMore: false,
      ));
    } catch (e) {
      if (!ref.mounted || token != _generation) return;
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: e),
      );
    }
  }
}

final nicBaseOptionInfiniteListProvider = AsyncNotifierProvider.autoDispose<
    NicBaseOptionInfiniteList, NicBaseOptionInfiniteListState>(
  NicBaseOptionInfiniteList.new,
  retry: (retryCount, error) => null,
);
