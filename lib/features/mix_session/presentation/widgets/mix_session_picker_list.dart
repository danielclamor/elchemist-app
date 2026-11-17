import 'package:elchemist_app/core/widgets/fading_vertical_scroll.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session.dart';
import 'package:elchemist_app/features/mix_session/presentation/widgets/mix_session_picker_list_tile.dart';
import 'package:elchemist_app/features/mix_session/providers/mix_session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MixSessionPickerList extends ConsumerStatefulWidget {
  final String formulaId;
  final MixSessionSummary? selected;
  final ValueChanged<MixSessionSummary> onSelected;

  const MixSessionPickerList({
    super.key,
    required this.formulaId,
    this.selected,
    required this.onSelected,
  });

  @override
  ConsumerState<MixSessionPickerList> createState() =>
      _MixSessionPickerListState();
}

class _MixSessionPickerListState extends ConsumerState<MixSessionPickerList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_maybeLoadMore);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _maybeLoadMore() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < 200) {
      ref
          .read(mixSessionByFormulaInfiniteListProvider(widget.formulaId)
              .notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final async =
        ref.watch(mixSessionByFormulaInfiniteListProvider(widget.formulaId));
    return async.when(
      error: (e, _) => Center(
        child: TextButton(
          onPressed: () => ref.invalidate(
              mixSessionByFormulaInfiniteListProvider(widget.formulaId)),
          child: Text('Failed to load. Retry\n$e'),
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      data: (list) {
        final items = list.page.items;

        if (items.isEmpty) {
          return const Center(
            child: Text(
              'No mix sessions',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoadMore());

        final showFooter = list.isLoadingMore || list.loadMoreError != null;

        return FadingVerticalScroll(
          controller: _scrollController,
          fadeHeight: 16,
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length + (showFooter ? 1 : 0),
            separatorBuilder: (context, index) => const Divider(
              height: 0.0,
              thickness: 0.25,
            ),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: list.loadMoreError != null
                        ? TextButton(
                            onPressed: () => ref
                                .read(mixSessionByFormulaInfiniteListProvider(
                                        widget.formulaId)
                                    .notifier)
                                .loadMore(retry: true),
                            child: const Text('Failed to load more. Retry'),
                          )
                        : const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                  ),
                );
              }
              final mixSession = items[index];
              return MixSessionPickerListTile(
                key: ValueKey(mixSession.id),
                mixSession: mixSession,
                isSelected: mixSession == widget.selected,
                onTap: () => widget.onSelected(mixSession),
              );
            },
          ),
        );
      },
    );
  }
}
