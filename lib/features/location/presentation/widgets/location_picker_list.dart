import 'package:elchemist_app/core/widgets/fading_vertical_scroll.dart';
import 'package:elchemist_app/features/location/domain/location.dart';
import 'package:elchemist_app/features/location/presentation/providers/location_providers.dart';
import 'package:elchemist_app/features/location/presentation/widgets/location_picker_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationPickerList extends ConsumerStatefulWidget {
  final List<LocationSummary> selectedList;
  final ValueChanged<LocationSummary> onSelected;

  const LocationPickerList({
    super.key,
    this.selectedList = const [],
    required this.onSelected,
  });

  @override
  ConsumerState<LocationPickerList> createState() => _LocationPickerListState();
}

class _LocationPickerListState extends ConsumerState<LocationPickerList> {
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
      ref.read(locationInfiniteListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(locationInfiniteListProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: TextButton(
          onPressed: () => ref.invalidate(locationInfiniteListProvider),
          child: Text('Failed to load. Retry\n$e'),
        ),
      ),
      data: (list) {
        final items = list.page.items;

        if (items.isEmpty) {
          return const Center(
            child: Text(
              'No locations',
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
                                .read(locationInfiniteListProvider.notifier)
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
              final location = items[index];
              final isSelected = widget.selectedList.contains(location);

              return LocationPickerListTile(
                key: ValueKey(location.id),
                location: location,
                isSelected: isSelected,
                onTap: () => widget.onSelected(location),
              );
            },
          ),
        );
      },
    );
  }
}
