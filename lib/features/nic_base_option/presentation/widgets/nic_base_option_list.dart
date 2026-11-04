import 'package:elchemist_app/core/widgets/fading_vertical_scroll.dart';
import 'package:elchemist_app/features/nic_base_option/domain/nic_base_option.dart';
import 'package:elchemist_app/features/nic_base_option/presentation/widgets/nic_base_option_list_tile.dart';
import 'package:elchemist_app/features/nic_base_option/providers/nic_base_option_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NicBaseOptionPickerList extends ConsumerStatefulWidget {
  final List<NicBaseOption> selectedList;
  final ValueChanged<NicBaseOption> onSelected;
  final bool disableHq;

  const NicBaseOptionPickerList({
    super.key,
    this.selectedList = const [],
    required this.onSelected,
    this.disableHq = false,
  });

  @override
  ConsumerState<NicBaseOptionPickerList> createState() =>
      _NicBaseOptionPickerListState();
}

class _NicBaseOptionPickerListState
    extends ConsumerState<NicBaseOptionPickerList> {
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
      ref.read(nicBaseOptionInfiniteListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(nicBaseOptionInfiniteListProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: TextButton(
          onPressed: () => ref.invalidate(nicBaseOptionInfiniteListProvider),
          child: Text('Failed to load. Retry\n$e'),
        ),
      ),
      data: (list) {
        final items = list.page.items;

        if (items.isEmpty) {
          return const Center(
            child: Text(
              'No nic base options',
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
          fadeHeight: 10,
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
                                .read(
                                    nicBaseOptionInfiniteListProvider.notifier)
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
              final nicBaseOption = items[index];
              final isSelected = widget.selectedList.contains(nicBaseOption);

              return NicBaseOptionPickerListTile(
                key: ValueKey(nicBaseOption.code),
                nicBaseOption: nicBaseOption,
                isSelected: isSelected,
                onTap: widget.disableHq
                    ? null
                    : () => widget.onSelected(nicBaseOption),
              );
            },
          ),
        );
      },
    );
  }
}
