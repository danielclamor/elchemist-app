import 'package:elchemist_app/core/graphql/graphql_client.dart';
import 'package:elchemist_app/features/formula/data/formula_repository.dart';
import 'package:elchemist_app/features/formula/domain/formula.dart';
import 'package:elchemist_app/features/formula/domain/formula_list_page.dart';
import 'package:elchemist_app/features/formula/domain/formula_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formulaRepositoryProvider = Provider<FormulaRepository>(
  (ref) => FormulaRepositoryImpl(ref.watch(graphQLClientProvider)),
);

const formulaPageSize = 50;

typedef FormulaPageKey = ({
  String? after,
});

final formulaListPageProvider =
    FutureProvider.autoDispose.family<FormulaListPage, FormulaPageKey>(
  (ref, key) => ref.watch(formulaRepositoryProvider).getListPage(
        first: formulaPageSize,
        after: key.after,
      ),
  retry: (retryCount, error) => null,
);

class FormulaListPagerState {
  final List<String?> cursors;
  final int index;

  const FormulaListPagerState({
    this.cursors = const [null],
    this.index = 0,
  });

  String? get currentCursor => cursors[index];
  bool get hasPreviousPage => index > 0;
  int get firstIndex => index * formulaPageSize + 1;

  FormulaListPagerState copyWith({
    List<String?>? cursors,
    int? index,
  }) =>
      FormulaListPagerState(
        cursors: cursors ?? this.cursors,
        index: index ?? this.index,
      );
}

class FormulaListPager extends Notifier<FormulaListPagerState> {
  @override
  FormulaListPagerState build() {
    return const FormulaListPagerState();
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

  void reset() => state = const FormulaListPagerState();
}

final formulaListPagerProvider =
    NotifierProvider.autoDispose<FormulaListPager, FormulaListPagerState>(
  FormulaListPager.new,
);

final formulaDetailsProvider =
    FutureProvider.autoDispose.family<Formula?, String>(
  (ref, id) => ref.watch(formulaRepositoryProvider).getDetails(id: id),
  retry: (retryCount, error) => null,
);
