import 'package:elchemist_app/core/widgets/fading_horizontal_scroll.dart';
import 'package:elchemist_app/core/widgets/fading_vertical_scroll.dart';
import 'package:elchemist_app/features/production_order/presentation/providers/production_order_providers.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_footer.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_header.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_tile.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_new_blink.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductionOrderListTable extends ConsumerStatefulWidget {
  const ProductionOrderListTable({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductionOrderListTable();
}

class _ProductionOrderListTable
    extends ConsumerState<ProductionOrderListTable> {
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pager = ref.watch(productionOrderListPagerProvider);
    final range = ref.watch(productionOrderDateRangeProvider);
    final status = ref.watch(productionOrderStatusFilterProvider);
    final pageKey = (after: pager.currentCursor, status: status, range: range);
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

    return Card(
      elevation: 2.0,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.zero,
      child: Column(
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
                      Divider(
                        height: 1.0,
                        thickness: 0.25,
                        color: Colors.black,
                      ),
                      pageAsync.when(
                        loading: () => Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (e, _) => Expanded(
                          child: Center(
                            child: TextButton(
                              onPressed: () => ref.invalidate(
                                productionOrderListPageProvider(pageKey),
                              ),
                              child: Text('Failed to load. Retry\n$e'),
                            ),
                          ),
                        ),
                        data: (page) {
                          if (page.items.isEmpty) {
                            return Expanded(
                              child: Center(
                                child: Text(
                                  'No orders',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            );
                          }
                          return Expanded(
                            child: Scrollbar(
                              controller: _verticalScrollController,
                              child: FadingVerticalScroll(
                                controller: _verticalScrollController,
                                fadeHeight: 16,
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: page.items.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(
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
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );

                if (needsScroll) {
                  return Scrollbar(
                    controller: _horizontalScrollController,
                    child: FadingHorizontalScroll(
                      controller: _horizontalScrollController,
                      child: tableContent,
                    ),
                  );
                }

                return tableContent;
              },
            ),
          ),
          Divider(
            height: 1.0,
            thickness: 0.25,
            color: Colors.black,
          ),
          pageAsync.when(
            loading: () => ProductionOrderListFooter(
              range: null,
              hasPreviousPage: false,
              hasNextPage: false,
              onPrevious: null,
              onNext: null,
            ),
            error: (e, _) => ProductionOrderListFooter(
              range: null,
              hasPreviousPage: false,
              hasNextPage: false,
              onPrevious: null,
              onNext: null,
            ),
            data: (page) => ProductionOrderListFooter(
              range: page.items.isEmpty
                  ? null
                  : (
                      first: pager.firstIndex,
                      last: pager.firstIndex + page.items.length - 1,
                    ),
              hasPreviousPage: page.hasPreviousPage,
              hasNextPage: page.hasNextPage,
              onPrevious: () => ref
                  .read(productionOrderListPagerProvider.notifier)
                  .previous(),
              onNext: () => ref
                  .read(productionOrderListPagerProvider.notifier)
                  .next(page.endCursor),
            ),
          ),
        ],
      ),
    );
  }
}
