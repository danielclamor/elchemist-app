import 'package:elchemist_app/features/production_order/presentation/providers/production_order_providers.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_footer.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_header.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_tile.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_new_blink.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductionOrderListTable extends ConsumerWidget {
  const ProductionOrderListTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pager = ref.watch(productionOrderListPagerProvider);
    final status = ref.watch(productionOrderStatusFilterProvider);
    final pageKey = (after: pager.currentCursor, status: status);
    final pageAsync = ref.watch(productionOrderListPageProvider(pageKey));
    ref.listen(
      productionOrderListPageProvider(pageKey),
      (prev, next) {
        final prevItems = prev?.value?.items;
        final nextItems = next.value?.items;
        if (prevItems == null || nextItems == null) return;

        final known = prevItems.map((o) => o.id).toSet();
        final added =
            nextItems.map((o) => o.id).where((id) => !known.contains(id));

        ref.read(productionOrderNewIdsProvider.notifier).markNew(added);
      },
    );

    return pageAsync.when(
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: TextButton(
          onPressed: () => ref.invalidate(
            productionOrderListPageProvider(pageKey),
          ),
          child: Text('Failed to load. Retry\n$e'),
        ),
      ),
      data: (page) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 0.0,
            shape: RoundedRectangleBorder(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                style: TextStyle(fontSize: 14.0),
                cursorWidth: 1.0,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 12.0,
                  ),
                  hintText: "Search",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    borderSide: const BorderSide(),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tableWidth = 1592.0;
                final needsScroll = constraints.maxWidth < tableWidth;

                final tableContent = SizedBox(
                  width: tableWidth,
                  child: Column(
                    children: [
                      ProductionOrderListHeader(),
                      Expanded(
                        child: ListView.separated(
                            itemCount: page.items.length,
                            separatorBuilder: (context, index) => Divider(
                                  height: 0.0,
                                  thickness: 0.25,
                                  color: Colors.grey.shade500,
                                ),
                            itemBuilder: (context, index) {
                              final order = page.items[index];
                              return ProductionOrderNewBlink(
                                key: ValueKey(order.id),
                                orderId: order.id,
                                child: ProductionOrderListTile(
                                  order: order,
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                );

                if (needsScroll) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: tableContent,
                  );
                }

                return tableContent;
              },
            ),
          ),
          ProductionOrderListFooter(
            firstIndex: pager.firstIndex,
            lastIndex: pager.firstIndex + page.items.length - 1,
            hasPreviousPage: pager.hasPreviousPage,
            hasNextPage: page.hasNextPage,
            onPrevious: () =>
                ref.read(productionOrderListPagerProvider.notifier).previous(),
            onNext: () => ref
                .read(productionOrderListPagerProvider.notifier)
                .next(page.endCursor),
          ),
        ],
      ),
    );
  }
}
