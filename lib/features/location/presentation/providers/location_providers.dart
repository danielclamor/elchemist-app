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
