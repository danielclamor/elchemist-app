import 'package:elchemist_app/core/widgets/fading_vertical_scroll.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_picker_list_tile.dart';
import 'package:elchemist_app/features/production_order/providers/production_order_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductionOrderPickerList extends ConsumerStatefulWidget {
  final String formulaId;
  final List<ProductionOrderSummary> selectedList;
  final ValueChanged<ProductionOrderSummary> onSelected;

  const ProductionOrderPickerList({
    super.key,
    required this.formulaId,
    this.selectedList = const [],
    required this.onSelected,
  });

  @override
  ConsumerState<ProductionOrderPickerList> createState() =>
      _ProductionOrderPickerListState();
}

class _ProductionOrderPickerListState
    extends ConsumerState<ProductionOrderPickerList> {
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
          .read(productionOrderAssignableToMixInfiniteListProvider(
            widget.formulaId,
          ).notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(
        productionOrderAssignableToMixInfiniteListProvider(widget.formulaId));

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: TextButton(
          onPressed: () => ref.invalidate(
              productionOrderAssignableToMixInfiniteListProvider(
                  widget.formulaId)),
          child: Text('Failed to load. Retry\n$e'),
        ),
      ),
      data: (list) {
        final items = list.page.items;

        if (items.isEmpty) {
          return const Center(
            child: Text(
              'No available production orders',
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
                                    productionOrderAssignableToMixInfiniteListProvider(
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
              final order = items[index];
              final isSelected = widget.selectedList.contains(order);

              return ProductionOrderPickerListTile(
                key: ValueKey(order.id),
                productionOrder: order,
                isSelected: isSelected,
                onTap: () => widget.onSelected(order),
              );
            },
          ),
        );
      },
    );
  }
}
