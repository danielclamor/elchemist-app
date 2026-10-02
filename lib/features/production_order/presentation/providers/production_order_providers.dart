import 'package:elchemist_app/core/graphql/graphql_client.dart';
import 'package:elchemist_app/features/production_order/data/production_order_repository.dart';
import 'package:elchemist_app/features/production_order/domain/production_order_list_page.dart';
import 'package:elchemist_app/features/production_order/domain/production_order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productionOrderRepositoryProvider = Provider<ProductionOrderRepository>(
  (ref) => ProductionOrderRepositoryImpl(ref.watch(graphQLClientProvider)),
);

const productionOrderPageSize = 50;

// final productionOrderListPageProvider =
//     FutureProvider.autoDispose.family<ProductionOrderListPage, String?>(
//   (ref, after) => ref
//       .watch(productionOrderRepositoryProvider)
//       .getListPage(first: productionOrderPageSize, after: after),
//   retry: (retryCount, error) => null,
// );

final productionOrderListPageProvider =
    StreamProvider.autoDispose.family<ProductionOrderListPage, String?>(
  (ref, after) {
    return ref
        .watch(productionOrderRepositoryProvider)
        .watchListPage(first: productionOrderPageSize, after: after);
  },
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

  void reset() => state = const ProductionOrderListPagerState();
}

final productionOrderListPagerProvider = NotifierProvider.autoDispose<
    ProductionOrderListPager, ProductionOrderListPagerState>(
  ProductionOrderListPager.new,
);
