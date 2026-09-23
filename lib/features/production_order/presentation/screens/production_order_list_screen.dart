import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_header.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_list_tile.dart';
import 'package:flutter/material.dart';

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
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width >= 800
            ? MediaQuery.of(context).size.width - 280
            : MediaQuery.of(context).size.width,
      ),
      padding: const EdgeInsets.all(24.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: AlignmentGeometry.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
                child: Text(
                  "Production Orders",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          child: ProductionOrderHeaderRow(),
                        ),
                        Divider(
                          height: 0.0,
                          thickness: 0.25,
                          color: Colors.grey.shade500,
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: orders.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 0.0,
                              thickness: 0.25,
                              color: Colors.grey.shade500,
                            ),
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              return ProductionOrderListTile(
                                orderNumber: order.orderNumber,
                                eliquidDescription: order.eliquidDescription,
                                orderedQuantity: order.orderedQuantity != null
                                    ? order.orderedQuantity.toString()
                                    : "--",
                                fulfilledQuantity:
                                    order.fulfilledQuantity != null
                                        ? order.fulfilledQuantity.toString()
                                        : "--",
                                createdAt: order.createdAt,
                                isPriority: order.isPriority,
                                job: order.job,
                                status: order.status,
                              );
                            },
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
            Divider(thickness: 0.25),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 16.0,
              ),
              child: Text("1"),
            ),
          ],
        ),
      ),
    );
  }
}
