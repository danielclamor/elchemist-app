import 'dart:async';

import 'package:elchemist_app/core/graphql/graphql_client.dart';
import 'package:elchemist_app/features/production_order/data/production_order_repository.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/domain/production_order_date_range.dart';
import 'package:elchemist_app/features/production_order/domain/production_order_list_page.dart';
import 'package:elchemist_app/features/production_order/domain/production_order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productionOrderRepositoryProvider = Provider<ProductionOrderRepository>(
  (ref) => ProductionOrderRepositoryImpl(ref.watch(graphQLClientProvider)),
);

const productionOrderPageSize = 50;

class ProductionOrderDatePresetFilter extends Notifier<DatePreset?> {
  @override
  DatePreset? build() => DatePreset.allTime;

  void select(DatePreset? preset) => state = preset;
}

final productionOrderDatePresetProvider =
    NotifierProvider<ProductionOrderDatePresetFilter, DatePreset?>(
  ProductionOrderDatePresetFilter.new,
);

final productionOrderDateRangeProvider = Provider<DateRange?>(
  (ref) =>
      ref.watch(productionOrderDatePresetProvider)?.toRange(DateTime.now()),
);

typedef ProductionOrderPageKey = ({
  String? after,
  ProductionOrderStatus? status,
  DateRange? range
});

class ProductionOrderStatusFilter extends Notifier<ProductionOrderStatus?> {
  @override
  ProductionOrderStatus? build() => null;

  void toggle(ProductionOrderStatus status) =>
      state = state == status ? null : status;
}

final productionOrderStatusFilterProvider =
    NotifierProvider<ProductionOrderStatusFilter, ProductionOrderStatus?>(
  ProductionOrderStatusFilter.new,
);

final productionOrderStatusCountsProvider = StreamProvider.autoDispose
    .family<Map<ProductionOrderStatus, int>, DateRange?>(
  (ref, range) => ref
      .watch(productionOrderRepositoryProvider)
      .watchStatusCounts(range: range),
);

final productionOrderListPageProvider = StreamProvider.autoDispose
    .family<ProductionOrderListPage, ProductionOrderPageKey>(
  (ref, key) => ref.watch(productionOrderRepositoryProvider).watchListPage(
        first: productionOrderPageSize,
        after: key.after,
        status: key.status,
        range: key.range,
      ),
  retry: (retryCount, error) => null,
);

class ProductionOrderListPagerState {
  final List<String?> cursors;
  final int index;

  const ProductionOrderListPagerState({
    this.cursors = const [null],
    this.index = 0,
  });

  String? get currentCursor => cursors[index];
  bool get hasPreviousPage => index > 0;
  int get firstIndex => index * productionOrderPageSize + 1;

  ProductionOrderListPagerState copyWith({
    List<String?>? cursors,
    int? index,
  }) =>
      ProductionOrderListPagerState(
        cursors: cursors ?? this.cursors,
        index: index ?? this.index,
      );
}

class ProductionOrderListPager extends Notifier<ProductionOrderListPagerState> {
  @override
  ProductionOrderListPagerState build() {
    ref.watch(productionOrderStatusFilterProvider);
    return const ProductionOrderListPagerState();
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

  void reset() => state = const ProductionOrderListPagerState();
}

final productionOrderListPagerProvider = NotifierProvider.autoDispose<
    ProductionOrderListPager, ProductionOrderListPagerState>(
  ProductionOrderListPager.new,
);

class ProductionOrderNewIds extends Notifier<Set<String>> {
  final _timers = <String, Timer>{};

  @override
  Set<String> build() {
    ref.onDispose(() {
      for (final t in _timers.values) {
        t.cancel();
      }
    });
    return {};
  }

  void markNew(Iterable<String> ids) {
    if (ids.isEmpty) return;
    state = {...state, ...ids};

    for (final id in ids) {
      _timers[id]?.cancel();
      _timers[id] = Timer(const Duration(seconds: 2), () {
        _timers.remove(id);
        state = state.where((e) => e != id).toSet();
      });
    }
  }
}

final productionOrderNewIdsProvider =
    NotifierProvider<ProductionOrderNewIds, Set<String>>(
  ProductionOrderNewIds.new,
);

const eliquidPastOrdersPreviewSize = 5;

final eliquidPastOrdersPreviewProvider =
    FutureProvider.autoDispose.family<ProductionOrderListPage, String>(
  (ref, eliquidId) =>
      ref.watch(productionOrderRepositoryProvider).getEliquidPastOrdersPage(
            eliquidId: eliquidId,
            first: eliquidPastOrdersPreviewSize,
          ),
  retry: (retryCount, error) => null,
);

typedef EliquidPastOrdersPageKey = ({
  String eliquidId,
  String? after,
});

final eliquidPastOrdersPageProvider = FutureProvider.autoDispose
    .family<ProductionOrderListPage, EliquidPastOrdersPageKey>(
  (ref, key) =>
      ref.watch(productionOrderRepositoryProvider).getEliquidPastOrdersPage(
            eliquidId: key.eliquidId,
            first: productionOrderPageSize,
            after: key.after,
          ),
  retry: (retryCount, error) => null,
);

class EliquidPastOrdersPager extends Notifier<ProductionOrderListPagerState> {
  EliquidPastOrdersPager(this.eliquidId);
  final String eliquidId;

  @override
  ProductionOrderListPagerState build() =>
      const ProductionOrderListPagerState();

  void next(String? endCursor) {
    if (endCursor == null) return;
    final cursors = [...state.cursors.sublist(0, state.index + 1), endCursor];
    state = state.copyWith(cursors: cursors, index: state.index + 1);
  }

  void previous() {
    if (!state.hasPreviousPage) return;
    state = state.copyWith(index: state.index - 1);
  }
}

final eliquidPastOrdersPagerProvider = NotifierProvider.autoDispose
    .family<EliquidPastOrdersPager, ProductionOrderListPagerState, String>(
  EliquidPastOrdersPager.new,
);

final productionOrderDetailsProvider =
    FutureProvider.autoDispose.family<ProductionOrder?, String>(
  (ref, id) => ref.watch(productionOrderRepositoryProvider).getDetails(id: id),
  retry: (retryCount, error) => null,
);
