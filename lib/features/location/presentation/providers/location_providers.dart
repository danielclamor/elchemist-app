import 'package:elchemist_app/core/graphql/graphql_client.dart';
import 'package:elchemist_app/features/location/data/location_repository.dart';
import 'package:elchemist_app/features/location/domain/location_list_page.dart';
import 'package:elchemist_app/features/location/domain/location_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationRepositoryProvider = Provider<LocationRepository>(
  (ref) => LocationRepositoryImpl(ref.watch(graphQLClientProvider)),
);

const locationPageSize = 50;

typedef LocationPageKey = ({
  String? after,
});

final locationSummaryListPageProvider =
    FutureProvider.autoDispose.family<LocationListPage, LocationPageKey>(
  (ref, key) => ref.watch(locationRepositoryProvider).getListPage(
        first: locationPageSize,
        after: key.after,
      ),
  retry: (retryCount, error) => null,
);

class LocationSummaryListPagerState {
  final List<String?> cursors;
  final int index;

  const LocationSummaryListPagerState({
    this.cursors = const [null],
    this.index = 0,
  });

  String? get currentCursor => cursors[index];
  bool get hasPreviousPage => index > 0;
  int get firstIndex => index * locationPageSize + 1;

  LocationSummaryListPagerState copyWith({
    List<String?>? cursors,
    int? index,
  }) =>
      LocationSummaryListPagerState(
        cursors: cursors ?? this.cursors,
        index: index ?? this.index,
      );
}

class LocationSummaryListPager extends Notifier<LocationSummaryListPagerState> {
  @override
  LocationSummaryListPagerState build() {
    // When you add filters (brand, search, ...), ref.watch their providers
    // here so changing one sends you back to page 1.
    // example ref.watch(eliquidFilterProvider);
    return const LocationSummaryListPagerState();
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

  void reset() => state = const LocationSummaryListPagerState();
}

final locationSummaryListPagerProvider = NotifierProvider.autoDispose<
    LocationSummaryListPager, LocationSummaryListPagerState>(
  LocationSummaryListPager.new,
);

class LocationInfiniteListState {
  final LocationListPage page;
  final bool isLoadingMore;
  final Object? loadMoreError;

  const LocationInfiniteListState({
    required this.page,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  LocationInfiniteListState copyWith({
    LocationListPage? page,
    bool? isLoadingMore,
    Object? loadMoreError,
    bool clearError = false,
  }) =>
      LocationInfiniteListState(
        page: page ?? this.page,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        loadMoreError:
            clearError ? null : (loadMoreError ?? this.loadMoreError),
      );
}

class LocationInfiniteList extends AsyncNotifier<LocationInfiniteListState> {
  int _generation = 0;

  @override
  Future<LocationInfiniteListState> build() async {
    _generation++; // any in-flight loadMore from before a rebuild is now stale
    // Later: ref.watch(locationSearchProvider) here, so a new search restarts the list.
    final page = await ref
        .watch(locationRepositoryProvider)
        .getListPage(first: locationPageSize);

    return LocationInfiniteListState(page: page);
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
      final next = await ref.read(locationRepositoryProvider).getListPage(
            first: locationPageSize,
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

final locationInfiniteListProvider = AsyncNotifierProvider.autoDispose<
    LocationInfiniteList, LocationInfiniteListState>(
  LocationInfiniteList.new,
  retry: (retryCount, error) => null,
);
