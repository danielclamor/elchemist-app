import 'package:elchemist_app/features/eliquid/domain/eliquid.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_job_chip.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_priority_chip.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

enum MoreAction { cancel, delete, archive }

class ProductionOrderDetailScreen extends StatefulWidget {
  final ProductionOrder productionOrder;

  const ProductionOrderDetailScreen({
    super.key,
    required this.productionOrder,
  });

  @override
  State<ProductionOrderDetailScreen> createState() =>
      _ProductionOrderDetailScreenState();
}

class _ProductionOrderDetailScreenState
    extends State<ProductionOrderDetailScreen> {
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

  ProductionOrderJobChip _getJobChip(
    ProductionOrderJob? job,
    ProductionOrderStatusChip statusChip,
  ) {
    if (job == null) {
      return ProductionOrderJobChip.unassigned();
    }

    switch (job) {
      case ProductionOrderJob.mix:
        return ProductionOrderJobChip.mix(
          fgColor: statusChip.fgColor,
          bgColor: statusChip.bgColor,
        );
      case ProductionOrderJob.repat:
        return ProductionOrderJobChip.repat(
          fgColor: statusChip.fgColor,
          bgColor: statusChip.bgColor,
        );
    }
  }

  String _getFormattedDate(DateTime datetime) {
    final local = datetime.toLocal();

    final timeStr = DateFormat('h:mm a').format(local); // ex. "9:00 PM"

    final monthDayYear =
        DateFormat('MMMM d, y').format(local); // ex. "September 9, 2025"
    return '$monthDayYear at $timeStr';
  }

  MoreAction? selectedMenu;

  @override
  Widget build(BuildContext context) {
    final po = widget.productionOrder;
    final eliquid = Eliquid(
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
                              '#${po.orderNumber}',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Gap(2.0),
                        Text(
                          _getFormattedDate(po.createdAt),
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Gap(4.0),
                        Row(
                          spacing: 4.0,
                          children: [
                            po.isPriority
                                ? ProductionOrderPriorityChip()
                                : SizedBox.shrink(),
                            _getStatusChip(po.status),
                            _getJobChip(po.job, _getStatusChip(po.status)),
                          ],
                        ),
                      ],
                    ),
                    MenuAnchor(
                      builder: (context, controller, child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 16.0,
                            ),
                          ),
                          onPressed: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              controller.open();
                            }
                          },
                          child: Row(
                            children: [
                              const Text('More actions'),
                              Gap(2.0),
                              Icon(Icons.arrow_drop_down_rounded)
                            ],
                          ),
                        );
                      },
                      menuChildren: List<MenuItemButton>.generate(
                        3,
                        (int index) => MenuItemButton(
                          onPressed: () => setState(
                              () => selectedMenu = MoreAction.values[index]),
                          child: Text('${MoreAction.values[index]}'),
                        ),
                      ),
                      alignmentOffset: Offset(0, 4),
                      style: MenuStyle(),
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
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: BoxBorder.all(width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        eliquid.description,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        eliquid.upc,
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    po.orderedQuantity != null
                                        ? 'x ${po.orderedQuantity}'
                                        : '',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              Gap(20.0),
                              Text(
                                "NIC PROFILE",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              eliquid.nicProfileFullName != null
                                  ? Text("${eliquid.nicProfileFullName}")
                                  : Text(
                                      "Not provided",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
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
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 16.0,
                                ),
                              ),
                              onPressed: () {},
                              child: Text("Assign to Mix"),
                            ),
                            ElevatedButton(
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
                              onPressed: () {},
                              child: Text("Assign to Streamline"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(40.0),
                Text(
                  "Timeline",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
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
