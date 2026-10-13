import 'package:elchemist_app/core/graphql/graphql_client.dart';
import 'package:elchemist_app/features/eliquid/data/eliquid_repository.dart';
import 'package:elchemist_app/features/eliquid/domain/eliquid_list_page.dart';
import 'package:elchemist_app/features/eliquid/domain/eliquid_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eliquidRepositoryProvider = Provider<EliquidRepository>(
  (ref) => EliquidRepositoryImpl(ref.watch(graphQLClientProvider)),
);

const eliquidPageSize = 50;

typedef EliquidPageKey = ({
  String? after,
});

final eliquidListPageProvider =
    FutureProvider.autoDispose.family<EliquidListPage, EliquidPageKey>(
  (ref, key) => ref.watch(eliquidRepositoryProvider).getListPage(
        first: eliquidPageSize,
        after: key.after,
      ),
  retry: (retryCount, error) => null,
);

class EliquidListPagerState {
  final List<String?> cursors;
  final int index;

  const EliquidListPagerState({
    this.cursors = const [null],
    this.index = 0,
  });

  String? get currentCursor => cursors[index];
  bool get hasPreviousPage => index > 0;
  int get firstIndex => index * eliquidPageSize + 1;

  EliquidListPagerState copyWith({
    List<String?>? cursors,
    int? index,
  }) =>
      EliquidListPagerState(
        cursors: cursors ?? this.cursors,
        index: index ?? this.index,
      );
}

class EliquidListPager extends Notifier<EliquidListPagerState> {
  @override
  EliquidListPagerState build() {
    // When you add filters (brand, search, ...), ref.watch their providers
    // here so changing one sends you back to page 1.
    // example ref.watch(eliquidFilterProvider);
    return const EliquidListPagerState();
  }

  void next(String? endCursor) {
    if (endCursor == null) return;
    final cursors = [...state.cursors.sublist(0, state.index + 1), endCursor];
    state = state.copyWith(cursors: cursors, index: state.index + 1);
  }

  void previous() {
    if (!state.hasPreviousPage) return;
    state = state.copyWith(index: state.index - 1);
  }

  void reset() => state = const EliquidListPagerState();
}

final eliquidListPagerProvider =
    NotifierProvider.autoDispose<EliquidListPager, EliquidListPagerState>(
  EliquidListPager.new,
);

class EliquidInfiniteListState {
  final EliquidListPage page;
  final bool isLoadingMore;
  final Object? loadMoreError;

  const EliquidInfiniteListState({
    required this.page,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  EliquidInfiniteListState copyWith({
    EliquidListPage? page,
    bool? isLoadingMore,
    Object? loadMoreError,
    bool clearError = false,
  }) =>
      EliquidInfiniteListState(
        page: page ?? this.page,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        loadMoreError:
            clearError ? null : (loadMoreError ?? this.loadMoreError),
      );
}

class EliquidInfiniteList extends AsyncNotifier<EliquidInfiniteListState> {
  int _generation = 0;

  @override
  Future<EliquidInfiniteListState> build() async {
    _generation++; // any in-flight loadMore from before a rebuild is now stale
    // Later: ref.watch(eliquidSearchProvider) here, so a new search restarts the list.
    final page = await ref
        .watch(eliquidRepositoryProvider)
        .getListPage(first: eliquidPageSize);

    return EliquidInfiniteListState(page: page);
  }

  Future<void> loadMore({bool retry = false}) async {
    final current = state.value;
    if (current == null || !current.page.hasNextPage || current.isLoadingMore) {
      return;
    }
    if (current.loadMoreError != null && !retry) {
      return; // don't auto-loop on errors
    }

    final token = _generation;
    state = AsyncData(
      current.copyWith(isLoadingMore: true, clearError: true),
    );

    try {
      final next = await ref.read(eliquidRepositoryProvider).getListPage(
            first: eliquidPageSize,
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

final eliquidInfiniteListProvider = AsyncNotifierProvider.autoDispose<
    EliquidInfiniteList, EliquidInfiniteListState>(
  EliquidInfiniteList.new,
  retry: (retryCount, error) => null,
);
