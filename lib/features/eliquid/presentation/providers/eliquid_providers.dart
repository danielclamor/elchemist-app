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

class EliquidListInfinitePagerState {
  final List<EliquidListPage> pages;

  const EliquidListInfinitePagerState({
    this.pages = const [],
  });

  EliquidListPage get lastPage => pages.last;
  String? get currentCursor => lastPage.endCursor;

  EliquidListInfinitePagerState copyWith({
    List<EliquidListPage>? pages,
  }) =>
      EliquidListInfinitePagerState(
        pages: pages ?? this.pages,
      );
}

class EliquidListInfinitePager extends Notifier<EliquidListInfinitePagerState> {
  @override
  EliquidListInfinitePagerState build() {
    return const EliquidListInfinitePagerState();
  }

  void next(EliquidListPage? page) {
    if (page == null) return;
    final pages = [...state.pages, page];
    state = state.copyWith(pages: pages);
  }

  void reset() => state = const EliquidListInfinitePagerState();
}

final eliquidListInfinitePagerProvider = NotifierProvider.autoDispose<
    EliquidListInfinitePager, EliquidListInfinitePagerState>(
  EliquidListInfinitePager.new,
);
