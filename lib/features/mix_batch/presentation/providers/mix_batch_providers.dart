import 'dart:async';

import 'package:elchemist_app/core/graphql/graphql_client.dart';
import 'package:elchemist_app/features/mix_batch/data/mix_batch_repository.dart';
import 'package:elchemist_app/features/mix_batch/domain/mix_batch_list_page.dart';
import 'package:elchemist_app/features/mix_batch/domain/mix_batch_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mixBatchRepositoryProvider = Provider<MixBatchRepository>(
  (ref) => MixBatchRepositoryImpl(ref.watch(graphQLClientProvider)),
);

const mixBatchPageSize = 50;

typedef MixBatchPageKey = ({
  String? after,
});

final mixBatchListPageProvider =
    StreamProvider.autoDispose.family<MixBatchListPage, MixBatchPageKey>(
  (ref, key) => ref.watch(mixBatchRepositoryProvider).watchListPage(
        first: mixBatchPageSize,
        after: key.after,
      ),
  retry: (retryCount, error) => null,
);

class MixBatchListPagerState {
  final List<String?> cursors;
  final int index;

  const MixBatchListPagerState({
    this.cursors = const [null],
    this.index = 0,
  });

  String? get currentCursor => cursors[index];
  bool get hasPreviousPage => index > 0;
  int get firstIndex => index * mixBatchPageSize + 1;

  MixBatchListPagerState copyWith({
    List<String?>? cursors,
    int? index,
  }) =>
      MixBatchListPagerState(
        cursors: cursors ?? this.cursors,
        index: index ?? this.index,
      );
}

class MixBatchListPager extends Notifier<MixBatchListPagerState> {
  @override
  MixBatchListPagerState build() {
    // ref.watch(mixBatchStatusFilterProvider);
    return const MixBatchListPagerState();
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

  void reset() => state = const MixBatchListPagerState();
}

final mixBatchListPagerProvider =
    NotifierProvider.autoDispose<MixBatchListPager, MixBatchListPagerState>(
  MixBatchListPager.new,
);

class MixBatchNewIds extends Notifier<Set<String>> {
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

final mixBatchNewIdsProvider = NotifierProvider<MixBatchNewIds, Set<String>>(
  MixBatchNewIds.new,
);
