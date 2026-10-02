import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/features/eliquid/domain/eliquid.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_status_chip.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/dialogs/production_order_add_eliquid_to_order_dialog.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/dialogs/production_order_add_locations_to_order_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ProductionOrderCreateOrderScreen extends StatefulWidget {
  const ProductionOrderCreateOrderScreen({super.key});

  @override
  State<ProductionOrderCreateOrderScreen> createState() =>
      _ProductionOrderCreateOrderScreenState();
}

class _ProductionOrderCreateOrderScreenState
    extends State<ProductionOrderCreateOrderScreen> {
  Eliquid? _selectedEliquid = Eliquid(
    id: "1",
    upc: "696177436003",
    description: "Black Jet Do More 60ml 0mg",
    brand: "Black Jet",
    chillType: ChillType.nonChilled,
    nicType: NicType.freebase,
    bottleSize: BottleSize.ml60,
    nicLevel: NicLevel.mg0,
    bottleColor: BottleColor.clear,
    nicProfileFullName: "Black Jet Do More Freebase - 0MG - Old Mix",
  );

  final orders = [
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
  ];

  final List<String> _selectedLocations = [
    "32 St.",
    "Macleod",
  ];

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isSameWeek(DateTime a, DateTime b) {
    final startA = _startOfWeek(a);
    final startB = _startOfWeek(b);
    return startA.year == startB.year &&
        startA.month == startB.month &&
        startA.day == startB.day;
  }

  DateTime _startOfWeek(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final daysSinceMonday = dateOnly.weekday - DateTime.monday; // Monday = 1
    return dateOnly.subtract(Duration(days: daysSinceMonday));
  }

  String _getFormattedDate(DateTime datetime) {
    final local = datetime.toLocal();
    final now = DateTime.now();

    final timeStr = DateFormat('h:mm a').format(local); // ex. "9:00 PM"

    if (_isSameDay(local, now)) {
      return 'Today at $timeStr';
    }

    if (_isSameWeek(local, now)) {
      final weekday = DateFormat('EEEE').format(local); // ex."Thursday"
      return '$weekday at $timeStr';
    }

    if (local.year == now.year) {
      final monthDay = DateFormat('MMM d').format(local); // ex. "Sep 9"
      return '$monthDay at $timeStr';
    }

    final monthDayYear =
        DateFormat('MMM d, y').format(local); // ex. "Sep 9, 2025"
    return '$monthDayYear at $timeStr';
  }

  ProductionOrderStatusChip _getStatusChip(ProductionOrderStatus status) {
    switch (status) {
      case ProductionOrderStatus.cancelled:
        return ProductionOrderStatusChip.cancelled();
      case ProductionOrderStatus.delivered:
        return ProductionOrderStatusChip.delivered();
      case ProductionOrderStatus.fulfilled:
        return ProductionOrderStatusChip.fulfilled();
      case ProductionOrderStatus.inProgress:
        return ProductionOrderStatusChip.inProgress();
      case ProductionOrderStatus.pending:
        return ProductionOrderStatusChip.pending();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 8.0,
                          children: [
                            Tooltip(
                              message: "Production Orders",
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    shape: const CircleBorder(),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Icon(
                                    Icons.arrow_back_ios_rounded,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Create Order',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(16.0),
                Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(8.0),
                  ),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _selectedEliquid != null
                        ? Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: BoxBorder.all(width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            _selectedEliquid!
                                                                .description,
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            _selectedEliquid!
                                                                .upc,
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: ElTextField(
                                                      controller:
                                                          TextEditingController(),
                                                      contentType:
                                                          ElTextFieldContentType
                                                              .numeric,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Gap(8.0),
                                        Expanded(
                                          flex: 0,
                                          child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: Size.zero,
                                                shape: const CircleBorder(),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _selectedEliquid = null;
                                                });
                                              },
                                              child: const Icon(
                                                Icons.close,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gap(8.0),
                                    _selectedLocations.isNotEmpty
                                        ? Column(
                                            spacing: 8.0,
                                            children: [
                                              Divider(
                                                thickness: 0.25,
                                              ),
                                              ..._selectedLocations.map(
                                                (location) {
                                                  return Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: SizedBox(),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  location,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Gap(16.0),
                                                                SizedBox(
                                                                  width: 100,
                                                                  child:
                                                                      ElTextField(
                                                                    controller:
                                                                        TextEditingController(),
                                                                    contentType:
                                                                        ElTextFieldContentType
                                                                            .numeric,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Gap(8.0),
                                                      Expanded(
                                                        flex: 0,
                                                        child: SizedBox(
                                                          width: 30,
                                                          height: 30,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              minimumSize:
                                                                  Size.zero,
                                                              shape:
                                                                  const CircleBorder(),
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                _selectedLocations
                                                                    .remove(
                                                                        location);
                                                              });
                                                            },
                                                            child: const Icon(
                                                              Icons.close,
                                                              size: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 16.0,
                                                ),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    final result =
                                                        await showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          const ProductionOrderAddLocationsToOrderDialog(),
                                                    );

                                                    if (result == null) return;
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surfaceContainer,
                                                    side: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surfaceContainer
                                                          .withAlpha(200),
                                                      width: 1.0,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 16.0,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "+ Location",
                                                    style: const TextStyle(
                                                      color: Color(0xFFDAF0FF),
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                              Gap(16.0),
                              Row(
                                spacing: 8.0,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0E76BD),
                                      side: BorderSide(
                                        color: const Color(0xFF0B5E97),
                                        width: 1.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 16.0,
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text("Create"),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final result = await showDialog(
                                      context: context,
                                      builder: (_) =>
                                          const ProductionOrderAddEliquidToOrderDialog(),
                                    );

                                    if (result == null) return;
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainer,
                                    side: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainer
                                          .withAlpha(200),
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
                                    "+ E-liquid",
                                    style: const TextStyle(
                                      color: Color(0xFFDAF0FF),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                Gap(40.0),
                Text(
                  "Past orders",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(16.0),
                Card(
                  elevation: 0.0,
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(8.0),
                  ),
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Card(
                        margin: EdgeInsets.zero,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: Column(
                            spacing: 12.0,
                            children: [
                              Row(
                                spacing: 4.0,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text("Order",
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text("Ordered",
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text("Fulfilled",
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text("Date",
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Status",
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListView.separated(
                        itemCount: orders.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 0.0,
                          thickness: 0.25,
                          color: Colors.grey.shade500,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final po = orders[index];
                          final isClosed =
                              po.status == ProductionOrderStatus.cancelled ||
                                  po.status == ProductionOrderStatus.delivered;
                          final String formattedDate =
                              _getFormattedDate(po.createdAt);
                          final textStyle = TextStyle(
                            fontSize: 14,
                            color: isClosed ? Colors.grey : null,
                            decoration:
                                po.status == ProductionOrderStatus.cancelled
                                    ? TextDecoration.lineThrough
                                    : null,
                            decorationColor: Colors.grey,
                            decorationThickness: 1.0,
                          );
                          final ProductionOrderStatusChip statusChip =
                              _getStatusChip(po.status);

                          return ListTile(
                            onTap: () {},
                            tileColor: po.status ==
                                        ProductionOrderStatus.cancelled ||
                                    po.status == ProductionOrderStatus.delivered
                                ? Theme.of(context).scaffoldBackgroundColor
                                : null,
                            contentPadding: EdgeInsets.zero,
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Row(
                                spacing: 4.0,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      po.orderNumber,
                                      style: textStyle,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      po.orderedQuantity != null
                                          ? po.orderedQuantity.toString()
                                          : "--",
                                      style: textStyle,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      po.fulfilledQuantity != null
                                          ? po.fulfilledQuantity.toString()
                                          : "--",
                                      style: textStyle,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      formattedDate,
                                      style: textStyle,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      alignment: AlignmentGeometry.centerLeft,
                                      child: statusChip,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Card(
                        margin: EdgeInsets.zero,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  foregroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 16.0,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text("View all"),
                                    Gap(8.0),
                                    Icon(Icons.arrow_forward),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
