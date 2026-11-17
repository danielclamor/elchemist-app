import 'dart:async';

import 'package:elchemist_app/core/graphql/graphql_client.dart';
import 'package:elchemist_app/features/mix_session/data/mix_session_repository.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session_list_page.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mixSessionRepositoryProvider = Provider<MixSessionRepository>(
  (ref) => MixSessionRepositoryImpl(ref.watch(graphQLClientProvider)),
);

const mixSessionPageSize = 50;

typedef MixSessionPageKey = ({
  String? after,
});

final mixSessionListPageProvider =
    StreamProvider.autoDispose.family<MixSessionListPage, MixSessionPageKey>(
  (ref, key) => ref.watch(mixSessionRepositoryProvider).watchListPage(
        first: mixSessionPageSize,
        after: key.after,
      ),
  retry: (retryCount, error) => null,
);

class MixSessionListPagerState {
  final List<String?> cursors;
  final int index;

  const MixSessionListPagerState({
    this.cursors = const [null],
    this.index = 0,
  });

  String? get currentCursor => cursors[index];
  bool get hasPreviousPage => index > 0;
  int get firstIndex => index * mixSessionPageSize + 1;

  MixSessionListPagerState copyWith({
    List<String?>? cursors,
    int? index,
  }) =>
      MixSessionListPagerState(
        cursors: cursors ?? this.cursors,
        index: index ?? this.index,
      );
}

class MixSessionListPager extends Notifier<MixSessionListPagerState> {
  @override
  MixSessionListPagerState build() {
    // ref.watch(mixSessionStatusFilterProvider);
    return const MixSessionListPagerState();
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

  void reset() => state = const MixSessionListPagerState();
}

final mixSessionListPagerProvider =
    NotifierProvider.autoDispose<MixSessionListPager, MixSessionListPagerState>(
  MixSessionListPager.new,
);

class MixSessionNewIds extends Notifier<Set<String>> {
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

final mixSessionNewIdsProvider =
    NotifierProvider<MixSessionNewIds, Set<String>>(
  MixSessionNewIds.new,
);

final mixSessionDetailsProvider =
    FutureProvider.autoDispose.family<MixSession?, String>(
  (ref, id) => ref.watch(mixSessionRepositoryProvider).getDetails(id: id),
  retry: (retryCount, error) => null,
);

class MixSessionVolumeMlValue extends Notifier<double> {
  @override
  double build() => 0.0;

  void set(String volumeMl) => state = double.tryParse(volumeMl) ?? 0.0;
}

final mixSessionVolumeMlValueProvider =
    NotifierProvider.autoDispose<MixSessionVolumeMlValue, double>(
  MixSessionVolumeMlValue.new,
);

class MixSessionSelectedTiles extends Notifier<Map<String, MixSessionSummary>> {
  @override
  Map<String, MixSessionSummary> build() => const {};

  void toggle(MixSessionSummary session) {
    if (state.containsKey(session.id)) {
      state = {...state}..remove(session.id);
    } else {
      state = {...state, session.id: session};
    }
  }

  void selectAll(List<MixSessionSummary> sessions) {
    state = {
      ...state,
      for (final session in sessions) session.id: session,
    };
  }

  void clear() {
    state = const {};
  }
}

final mixSessionSelectedTilesProvider =
    NotifierProvider<MixSessionSelectedTiles, Map<String, MixSessionSummary>>(
  MixSessionSelectedTiles.new,
);

class MixSessionInfiniteListState {
  final MixSessionListPage page;
  final bool isLoadingMore;
  final Object? loadMoreError;

  const MixSessionInfiniteListState({
    required this.page,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  MixSessionInfiniteListState copyWith({
    MixSessionListPage? page,
    bool? isLoadingMore,
    Object? loadMoreError,
    bool clearError = false,
  }) =>
      MixSessionInfiniteListState(
        page: page ?? this.page,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        loadMoreError:
            clearError ? null : (loadMoreError ?? this.loadMoreError),
      );
}

class MixSessionByFormulaInfiniteList
    extends AsyncNotifier<MixSessionInfiniteListState> {
  MixSessionByFormulaInfiniteList(this.formulaId);

  final String formulaId;

  int _generation = 0;

  @override
  Future<MixSessionInfiniteListState> build() async {
    _generation++;
    final page = await ref.watch(mixSessionRepositoryProvider).getListPage(
          first: mixSessionPageSize,
          formulaId: formulaId,
        );
    return MixSessionInfiniteListState(page: page);
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
      final next = await ref.read(mixSessionRepositoryProvider).getListPage(
            first: mixSessionPageSize,
            formulaId: formulaId,
            after: current.page.endCursor,
          );
      if (!ref.mounted || token != _generation) return;

      final latest = state.value ?? current;
      state = AsyncData(latest.copyWith(
        page: latest.page.append(next),
        isLoadingMore: false,
        clearError: true,
      ));
    } catch (e) {
      if (!ref.mounted || token != _generation) return;

      final latest = state.value ?? current;
      state = AsyncData(
        latest.copyWith(isLoadingMore: false, loadMoreError: e),
      );
    }
  }
}

final mixSessionByFormulaInfiniteListProvider =
    AsyncNotifierProvider.autoDispose.family<MixSessionByFormulaInfiniteList,
        MixSessionInfiniteListState, String>(
  MixSessionByFormulaInfiniteList.new,
);
