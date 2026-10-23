import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/domain/production_order_activity_log.dart';
import 'package:elchemist_app/features/production_order/presentation/providers/production_order_providers.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_job_chip.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_priority_chip.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/chips/production_order_status_chip.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/dialogs/production_order_input_quantity_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

enum MoreActionsItemType {
  cancel,
  delete,
  archive;

  @override
  String toString() {
    return switch (this) {
      MoreActionsItemType.cancel => 'Cancel',
      MoreActionsItemType.delete => 'Delete',
      MoreActionsItemType.archive => 'Archive',
    };
  }
}

class ProductionOrderDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const ProductionOrderDetailScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductionOrderDetailScreenState();
}

class _ProductionOrderDetailScreenState
    extends ConsumerState<ProductionOrderDetailScreen> {
  ProductionOrderStatusChip _getStatusChip(ProductionOrderStatus? status) {
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
      default:
        return ProductionOrderStatusChip(
          labelIcon: null,
          labelText: "",
          fgColor: Colors.grey,
          bgColor: Colors.grey,
        );
    }
  }

  ProductionOrderJobChip _getJobChip(
    ProductionOrderJobType? job,
    ProductionOrderStatusChip statusChip,
  ) {
    if (job == null) {
      return ProductionOrderJobChip.unassigned(
        fgColor: statusChip.fgColor,
        bgColor: statusChip.bgColor,
      );
    }

    switch (job) {
      case ProductionOrderJobType.mix:
        return ProductionOrderJobChip.mix(
          fgColor: statusChip.fgColor,
          bgColor: statusChip.bgColor,
        );
      case ProductionOrderJobType.repat:
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

  MoreActionsItemType? selectedMenu;

  bool _isSubmitting = false;

  void _showError(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  Future<bool> _showConfirmationDialog(MoreActionsItemType type) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('${type.toString()} order?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(type.toString()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _delete() async {
    final bool shouldDelete = await _showConfirmationDialog(
      MoreActionsItemType.delete,
    );
    if (!shouldDelete) return;

    setState(() => _isSubmitting = true);

    try {
      await ref
          .read(productionOrderRepositoryProvider)
          .deleteOrder(id: widget.id);

      if (!mounted) return;

      Navigator.of(context).pop();

      ref.invalidate(
          productionOrderListPageProvider); // every cursor/filter instance refetches now
      ref.invalidate(productionOrderStatusCountsProvider);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showError(e is Exception
          ? e.toString()
          : 'Something went wrong. Please try again.');
    }
  }

  Future<void> _cancel() async {
    final bool shouldCancel = await _showConfirmationDialog(
      MoreActionsItemType.cancel,
    );
    if (!shouldCancel) return;

    setState(() => _isSubmitting = true);
  }

  void _showInputQuantityDialog(
    int? orderedQuantity,
    ProductionOrderJobType jobType,
  ) {
    showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProductionOrderInputQuantityDialog(
        id: widget.id,
        orderedQuantity: orderedQuantity,
        jobType: jobType,
      ),
    );
  }

  List<MenuItemButton> _menuItemButtons() => [
        MenuItemButton(
          onPressed: () => _cancel(),
          leadingIcon: Icon(
            Icons.close,
            size: 16,
          ),
          child: Text(MoreActionsItemType.cancel.toString()),
        ),
        MenuItemButton(
          onPressed: () => _delete(),
          leadingIcon: Icon(
            Icons.delete,
            size: 16,
          ),
          child: Text(MoreActionsItemType.delete.toString()),
        ),
        MenuItemButton(
          onPressed: () {},
          leadingIcon: Icon(
            Icons.archive,
            size: 16,
          ),
          child: Text(MoreActionsItemType.archive.toString()),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final id = widget.id;
    final async = ref.watch(productionOrderDetailsProvider(id));
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
                            async.when(
                              data: (data) => Text(
                                data != null ? '#${data.orderNumber}' : "",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              error: (error, stackTrace) => Text(
                                "",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              loading: () => Container(
                                width: 40,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Gap(2.0),
                        Text(
                          async.when(
                            data: (data) => data != null
                                ? _getFormattedDate(data.createdAt)
                                : "",
                            error: (error, stackTrace) => "",
                            loading: () => "",
                          ),
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Gap(4.0),
                        Row(
                          spacing: 4.0,
                          children: [
                            async.when(
                              data: (data) => data != null
                                  ? data.isPriority
                                      ? ProductionOrderPriorityChip()
                                      : SizedBox.shrink()
                                  : SizedBox.shrink(),
                              error: (e, _) => SizedBox.shrink(),
                              loading: () => SizedBox.shrink(),
                            ),
                            _getStatusChip(
                              async.when(
                                data: (data) => data?.status,
                                error: (e, _) => null,
                                loading: () => null,
                              ),
                            ),
                            async.when(
                              data: (data) => data != null
                                  ? _getJobChip(
                                      data.jobType,
                                      _getStatusChip(data.status),
                                    )
                                  : SizedBox.shrink(),
                              error: (e, _) => SizedBox.shrink(),
                              loading: () => SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox.shrink()),
                    async.when(
                      error: (e, _) => SizedBox.shrink(),
                      loading: () => SizedBox.shrink(),
                      data: (data) {
                        if (data?.status == ProductionOrderStatus.cancelled) {
                          return SizedBox.shrink();
                        }

                        return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 16.0,
                            ),
                          ),
                          onPressed: () {}, // TODO implement edit state
                          label: Text("Edit"),
                          icon: Icon(Icons.edit),
                        );
                      },
                    ),
                    Gap(8.0),
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
                      menuChildren: _menuItemButtons(),
                      alignmentOffset: Offset(0, 4),
                      style: MenuStyle(),
                      crossAxisUnconstrained: false,
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
                    child: async.when(
                      loading: () => SizedBox.shrink(),
                      error: (e, _) => Center(
                        child: TextButton(
                          onPressed: () => ref
                              .invalidate(productionOrderDetailsProvider(id)),
                          child: Text('Failed to load. Retry\n$e'),
                        ),
                      ),
                      data: (data) => data != null
                          ? Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: BoxBorder.all(width: 1.0),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                data.eliquid.description,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                data.eliquid.upc,
                                                style:
                                                    TextStyle(fontSize: 14.0),
                                              ),
                                            ],
                                          ),
                                          data.orderedQuantity != null
                                              ? Row(
                                                  children: [
                                                    Text(
                                                      'x',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                    Gap(8.0),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        '${data.orderedQuantity}',
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  '--',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                        ],
                                      ),
                                      Gap(20.0),
                                      data.allocations.isNotEmpty
                                          ? Column(
                                              spacing: 8.0,
                                              children: [
                                                Divider(
                                                  thickness: 0.25,
                                                ),
                                                ...data.allocations.map(
                                                  (allocation) {
                                                    return Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              allocation
                                                                  .location
                                                                  .name,
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Gap(16.0),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'x',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                  ),
                                                                ),
                                                                Gap(8.0),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .surface,
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      16.0,
                                                                    ),
                                                                  ),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8.0),
                                                                  child: Text(
                                                                    allocation
                                                                        .quantity
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                Gap(16.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Priority',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Checkbox(
                                      value: data.isPriority,
                                      visualDensity: VisualDensity.compact,
                                      onChanged: null,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    ),
                  ),
                ),
                Gap(16.0),
                async.when(
                  error: (e, _) => SizedBox.shrink(),
                  loading: () => SizedBox.shrink(),
                  data: (data) {
                    if (data == null ||
                        data.status == ProductionOrderStatus.cancelled) {
                      return SizedBox.shrink();
                    }

                    final jobType = data.jobType;
                    final isAssigned = jobType != null;

                    List<Widget> rowChildren = [];

                    if (data.status == ProductionOrderStatus.fulfilled) {
                      rowChildren = [
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
                          onPressed: !_isSubmitting
                              ? () => _showInputQuantityDialog(
                                    data.orderedQuantity,
                                    ProductionOrderJobType.mix,
                                  )
                              : null,
                          child: Text("Mark as delivered"),
                        ),
                      ];
                    }

                    if (!isAssigned) {
                      rowChildren = [
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
                          onPressed: !_isSubmitting
                              ? () => _showInputQuantityDialog(
                                    data.orderedQuantity,
                                    ProductionOrderJobType.mix,
                                  )
                              : null,
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
                          onPressed: !_isSubmitting
                              ? () => _showInputQuantityDialog(
                                    data.orderedQuantity,
                                    ProductionOrderJobType.repat,
                                  )
                              : null,
                          child: Text("Assign to Streamline"),
                        ),
                      ];
                    }

                    if (isAssigned && jobType == ProductionOrderJobType.repat) {
                      rowChildren = [
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
                          onPressed: !_isSubmitting ? () {} : null,
                          child: Text("Mark as fulfilled"),
                        ),
                      ];
                    }

                    if (rowChildren.isNotEmpty) {
                      return Row(
                        spacing: 8.0,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: rowChildren,
                      );
                    }

                    return SizedBox.fromSize();
                  },
                ),
                Gap(40.0),
                Text(
                  "Timeline",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(20),
                async.when(
                  data: (data) => data != null
                      ? ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final activityLog = data.activityLogs[index];
                            final oldValue = activityLog.oldValue;
                            final newValue = activityLog.newValue;

                            return switch (activityLog.type) {
                              ProductionOrderActivityType.created => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.radio_button_checked_rounded,
                                          size: 12,
                                        ),
                                        Gap(12.0),
                                        Text(
                                          "Order #${data.orderNumber} created.",
                                        ),
                                      ],
                                    ),
                                    Text(
                                      _getFormattedDate(
                                          activityLog.triggeredAt),
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ProductionOrderActivityType.adjustQuantity =>
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .radio_button_checked_rounded,
                                              size: 12,
                                            ),
                                            Gap(12.0),
                                            Text(
                                              "Adjusted quantity from $oldValue to $newValue.",
                                            ),
                                          ],
                                        ),
                                        Text(
                                          _getFormattedDate(
                                              activityLog.triggeredAt),
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: Container(
                                        height: 24,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ProductionOrderActivityType.changeStatus =>
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .radio_button_checked_rounded,
                                              size: 12,
                                            ),
                                            Gap(12.0),
                                            Text(
                                              "Status changed from $oldValue to $newValue.",
                                            ),
                                          ],
                                        ),
                                        Text(
                                          _getFormattedDate(
                                              activityLog.triggeredAt),
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: Container(
                                        height: 24,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ProductionOrderActivityType.switchPriority =>
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .radio_button_checked_rounded,
                                              size: 12,
                                            ),
                                            Gap(12.0),
                                            Text("Priority changed"),
                                          ],
                                        ),
                                        Text(
                                          _getFormattedDate(
                                              activityLog.triggeredAt),
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: Container(
                                        height: 24,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ProductionOrderActivityType.toggleArchived =>
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .radio_button_checked_rounded,
                                              size: 12,
                                            ),
                                            Gap(12.0),
                                            Text("Archived"),
                                          ],
                                        ),
                                        Text(
                                          _getFormattedDate(
                                              activityLog.triggeredAt),
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: Container(
                                        height: 24,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ProductionOrderActivityType.assignJob => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .radio_button_checked_rounded,
                                              size: 12,
                                            ),
                                            Gap(12.0),
                                            Text("Assigned to $newValue"),
                                          ],
                                        ),
                                        Text(
                                          _getFormattedDate(
                                              activityLog.triggeredAt),
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: Container(
                                        height: 24,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                            };
                          },
                          itemCount: data.activityLogs.length,
                        )
                      : SizedBox.shrink(),
                  error: (e, _) => SizedBox.shrink(),
                  loading: () => SizedBox.shrink(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
