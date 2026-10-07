import 'package:elchemist_app/core/widgets/fading_horizontal_scroll.dart';
import 'package:elchemist_app/core/widgets/fading_vertical_scroll.dart';
import 'package:elchemist_app/features/production_order/presentation/providers/production_order_providers.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_footer.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_header.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class EliquidPastOrdersDialog extends ConsumerStatefulWidget {
  final String eliquidId;

  const EliquidPastOrdersDialog({
    super.key,
    required this.eliquidId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EliquidPastOrdersDialog();
}

class _EliquidPastOrdersDialog extends ConsumerState<EliquidPastOrdersDialog> {
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
    final eliquidId = widget.eliquidId;
    final pager = ref.watch(eliquidPastOrdersPagerProvider(eliquidId));
    final pageKey = (eliquidId: eliquidId, after: pager.currentCursor);
    final pageAsync = ref.watch(eliquidPastOrdersPageProvider(pageKey));

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      clipBehavior: Clip.hardEdge,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 1592.0,
          maxHeight: 720,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          shape: const CircleBorder(),
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainer,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                  Gap(8.0),
                  TextField(
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
                ],
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
                        ProductionOrderListHeader(
                          cardColor:
                              Theme.of(context).colorScheme.surfaceContainer,
                        ),
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
                                  eliquidPastOrdersPageProvider(pageKey),
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
                                      return ProductionOrderListTile(
                                        order: order,
                                      );
                                    },
                                  ),
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
                cardColor: Theme.of(context).colorScheme.surfaceContainer,
                range: page.items.isEmpty
                    ? null
                    : (
                        first: pager.firstIndex,
                        last: pager.firstIndex + page.items.length - 1,
                      ),
                hasPreviousPage: page.hasPreviousPage,
                hasNextPage: page.hasNextPage,
                onPrevious: () => ref
                    .read(eliquidPastOrdersPagerProvider(eliquidId).notifier)
                    .previous(),
                onNext: () => ref
                    .read(eliquidPastOrdersPagerProvider(eliquidId).notifier)
                    .next(page.endCursor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
