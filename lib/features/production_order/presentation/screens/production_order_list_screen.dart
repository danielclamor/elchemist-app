import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/screens/production_order_create_order_screen.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_table.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
