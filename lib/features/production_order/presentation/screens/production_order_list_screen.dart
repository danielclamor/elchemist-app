import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/providers/production_order_providers.dart';
import 'package:elchemist_app/features/production_order/presentation/screens/production_order_create_order_screen.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_footer.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_header.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ProductionOrderListTable extends ConsumerWidget {
  const ProductionOrderListTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pager = ref.watch(productionOrderListPagerProvider);
    final pageAsync = ref.watch(
      productionOrderListPageProvider(pager.currentCursor),
    );

    return pageAsync.when(
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: TextButton(
          onPressed: () => ref
              .invalidate(productionOrderListPageProvider(pager.currentCursor)),
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
                      Divider(
                        height: 0.0,
                        thickness: 0.25,
                        color: Colors.grey.shade500,
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: page.items.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 0.0,
                            thickness: 0.25,
                            color: Colors.grey.shade500,
                          ),
                          itemBuilder: (context, index) =>
                              ProductionOrderListTile(
                            order: page.items[index],
                          ),
                        ),
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

class ProductionOrderListScreen extends StatefulWidget {
  const ProductionOrderListScreen({super.key});

  @override
  State<ProductionOrderListScreen> createState() =>
      _ProductionOrderListScreenState();
}

class _ProductionOrderListScreenState extends State<ProductionOrderListScreen> {
  static final orders = [
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.pending,
      orderedQuantity: null,
      fulfilledQuantity: null,
      isPriority: true,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: null,
      createdAt: DateTime.parse("2026-09-23 16:39:46.271 -0600"),
    ),
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.inProgress,
      orderedQuantity: 10,
      fulfilledQuantity: null,
      isPriority: true,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: ProductionOrderJob.mix,
      createdAt: DateTime.parse("2026-09-22 16:39:46.271 -0600"),
    ),
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.cancelled,
      orderedQuantity: 10,
      fulfilledQuantity: null,
      isPriority: false,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: ProductionOrderJob.repat,
      createdAt: DateTime.parse("2026-09-16 16:39:46.271 -0600"),
    ),
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.fulfilled,
      orderedQuantity: 10,
      fulfilledQuantity: 10,
      isPriority: false,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: ProductionOrderJob.mix,
      createdAt: DateTime.parse("2026-09-16 16:39:46.271 -0600"),
    ),
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.fulfilled,
      orderedQuantity: 10,
      fulfilledQuantity: 12,
      isPriority: false,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: ProductionOrderJob.mix,
      createdAt: DateTime.parse("2026-09-16 16:39:46.271 -0600"),
    ),
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.fulfilled,
      orderedQuantity: 10,
      fulfilledQuantity: 10,
      isPriority: false,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: ProductionOrderJob.mix,
      createdAt: DateTime.parse("2026-09-16 16:39:46.271 -0600"),
    ),
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.fulfilled,
      orderedQuantity: 10,
      fulfilledQuantity: 10,
      isPriority: false,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: ProductionOrderJob.mix,
      createdAt: DateTime.parse("2026-09-16 16:39:46.271 -0600"),
    ),
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.fulfilled,
      orderedQuantity: 10,
      fulfilledQuantity: 10,
      isPriority: false,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: ProductionOrderJob.mix,
      createdAt: DateTime.parse("2026-09-16 16:39:46.271 -0600"),
    ),
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.fulfilled,
      orderedQuantity: 10,
      fulfilledQuantity: 10,
      isPriority: true,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: ProductionOrderJob.mix,
      createdAt: DateTime.parse("2026-09-16 16:39:46.271 -0600"),
    ),
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.delivered,
      orderedQuantity: 10,
      fulfilledQuantity: 10,
      isPriority: false,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: ProductionOrderJob.mix,
      createdAt: DateTime.parse("2026-09-16 16:39:46.271 -0600"),
    ),
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.delivered,
      orderedQuantity: 10,
      fulfilledQuantity: 10,
      isPriority: true,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: ProductionOrderJob.mix,
      createdAt: DateTime.parse("2026-09-16 16:39:46.271 -0600"),
    ),
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.delivered,
      orderedQuantity: 10,
      fulfilledQuantity: 10,
      isPriority: false,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: ProductionOrderJob.mix,
      createdAt: DateTime.parse("2026-09-16 16:39:46.271 -0600"),
    ),
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.delivered,
      orderedQuantity: 10,
      fulfilledQuantity: 10,
      isPriority: false,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: ProductionOrderJob.mix,
      createdAt: DateTime.parse("2026-09-16 16:39:46.271 -0600"),
    ),
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.delivered,
      orderedQuantity: 10,
      fulfilledQuantity: 10,
      isPriority: false,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: ProductionOrderJob.mix,
      createdAt: DateTime.parse("2026-09-16 16:39:46.271 -0600"),
    ),
    ProductionOrderSummary(
      id: "UHJvZHVjdGlvbk9yZGVyVHlwZToxNmIzMzQxMC1kYzhiLTQ2MWMtOTIyZC0xYzFmZTYxNzQ4ODA=",
      orderNumber: "2026091600001",
      status: ProductionOrderStatus.delivered,
      orderedQuantity: 10,
      fulfilledQuantity: 10,
      isPriority: false,
      eliquidDescription: "Black Jet Do More 60ML 0MG",
      job: ProductionOrderJob.mix,
      createdAt: DateTime.parse("2026-09-16 16:39:46.271 -0600"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width >= 800
              ? MediaQuery.of(context).size.width - 280
              : MediaQuery.of(context).size.width,
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Production Orders",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductionOrderCreateOrderScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E76BD),
                    side: BorderSide(
                      color: const Color(0xFF0B5E97),
                      width: 1.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                  ),
                  child: Text(
                    "Create Order",
                    style: const TextStyle(
                      color: Color(0xFFDAF0FF),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            Card(
              elevation: 2.0,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 1.0,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48.0,
                          vertical: 16.0,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16.0,
                            ),
                            Gap(12.0),
                            Text(
                              'Today',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              width: 1.0,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48.0,
                            vertical: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pending',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                orders
                                    .where((o) =>
                                        o.status ==
                                        ProductionOrderStatus.pending)
                                    .length
                                    .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              width: 1.0,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48.0,
                            vertical: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'In progress',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                orders
                                    .where((o) =>
                                        o.status ==
                                        ProductionOrderStatus.inProgress)
                                    .length
                                    .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              width: 1.0,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48.0,
                            vertical: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Fulfilled',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                orders
                                    .where((o) =>
                                        o.status ==
                                        ProductionOrderStatus.fulfilled)
                                    .length
                                    .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              width: 1.0,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48.0,
                            vertical: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivered',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                orders
                                    .where((o) =>
                                        o.status ==
                                        ProductionOrderStatus.delivered)
                                    .length
                                    .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Card(
                elevation: 2.0,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: EdgeInsets.zero,
                child: ProductionOrderListTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
