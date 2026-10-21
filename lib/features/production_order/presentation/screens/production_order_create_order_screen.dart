import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/features/eliquid/domain/eliquid.dart';
import 'package:elchemist_app/features/location/domain/location.dart';
import 'package:elchemist_app/features/production_order/domain/production_order_repository.dart';
import 'package:elchemist_app/features/production_order/presentation/providers/production_order_providers.dart';
import 'package:elchemist_app/features/production_order/presentation/screens/production_order_detail_screen.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/allocation_entry_row.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/dialogs/production_order_add_eliquid_to_order_dialog.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/dialogs/production_order_add_locations_to_order_dialog.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/eliquid_past_orders_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

// TODO fix layout

class ProductionOrderCreateOrderScreen extends ConsumerStatefulWidget {
  const ProductionOrderCreateOrderScreen({super.key});

  @override
  ConsumerState<ProductionOrderCreateOrderScreen> createState() =>
      _ProductionOrderCreateOrderScreenState();
}

class _ProductionOrderCreateOrderScreenState
    extends ConsumerState<ProductionOrderCreateOrderScreen> {
  EliquidSummary? _selectedEliquid;
  List<LocationSummary> _selectedLocations = [];

  final _quantityController = TextEditingController();
  final _quantityFocusNode = FocusNode();

  bool _isPriority = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _quantityController.dispose();
    _quantityFocusNode.dispose();
    super.dispose();
  }

  final _allocationEntries = <String, AllocationEntry>{};

  AllocationEntry _allocationEntry(LocationSummary l) =>
      _allocationEntries.putIfAbsent(l.id, () => AllocationEntry(location: l));

  int _totalAllocationQuantity() =>
      _allocationEntries.values.fold(0, (sum, e) => sum + e.quantity);

  void _disposeAllocationEntry(String id) {
    final entry = _allocationEntries.remove(id);
    WidgetsBinding.instance.addPostFrameCallback((_) => entry?.dispose());
    _selectQuantityText();
  }

  void _removeAllocation(LocationSummary l) {
    setState(() => _selectedLocations.remove(l));
    _disposeAllocationEntry(l.id);
    _selectQuantityText();
  }

  void _selectQuantityText() {
    final length = _quantityController.text.length;
    if (length > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _quantityFocusNode.requestFocus();
        _quantityController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: length,
        );
      });
    }
  }

  void _selectAllocationQuantityText(String id) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final entry = _allocationEntries[id];
      if (entry != null) {
        entry.focusNode.requestFocus();
        entry.controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: entry.controller.text.length,
        );
      }
    });
  }

  Widget _addLocationsButton() => ElevatedButton(
        onPressed: _selectedEliquid != null
            ? () async {
                final locations = await showDialog<List<LocationSummary>>(
                  context: context,
                  builder: (_) => ProductionOrderAddLocationsToOrderDialog(
                    selectedList: _selectedLocations,
                  ),
                );

                if (locations != null) {
                  if (!mounted) return;

                  final selectedIds = locations.map((l) => l.id).toSet();
                  final newIds = selectedIds
                      .where((id) => !_allocationEntries.keys.contains(id));
                  final removedIds = _allocationEntries.keys
                      .where((id) => !selectedIds.contains(id))
                      .toList();

                  setState(() {
                    _selectedLocations = locations;
                  });

                  removedIds.forEach(_disposeAllocationEntry);

                  _selectAllocationQuantityText(newIds.first);
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          side: BorderSide(
            color:
                Theme.of(context).colorScheme.surfaceContainer.withAlpha(200),
            width: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(16.0),
          textStyle: const TextStyle(
            color: Color(0xFFDAF0FF),
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        child: Text(
          "+ Location",
        ),
      );

  void _selectEliquid(BuildContext context) async {
    final eliquid = await showDialog<EliquidSummary>(
      context: context,
      builder: (_) => ProductionOrderAddEliquidToOrderDialog(
        selected: _selectedEliquid,
      ),
    );

    if (eliquid != null) {
      setState(() {
        _selectedEliquid = eliquid;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Added ${eliquid.description}'),
        ));
      }
    }
  }

  Widget _addEliquidButton() => ElevatedButton(
        onPressed: () => _selectEliquid(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          side: BorderSide(
            color:
                Theme.of(context).colorScheme.surfaceContainer.withAlpha(200),
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
      );

  Widget _createOrderButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0E76BD),
          side: _selectedEliquid != null
              ? BorderSide(
                  color: const Color(0xFF0B5E97),
                  width: 1.0,
                )
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
        ),
        onPressed: _selectedEliquid != null ? () => _submit() : null,
        child: Text("Create"),
      );

  void _showError(String message) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));

  Future<void> _submit() async {
    final eliquid = _selectedEliquid;
    if (eliquid == null || _isSubmitting) return;

    final allocations = <AllocationInput>[
      for (final l in _selectedLocations)
        (
          locationId: l.id,
          quantity:
              int.tryParse(_allocationEntry(l).controller.text.trim()) ?? 0,
        )
    ];

    if (allocations.any((a) => a.quantity <= 0)) {
      _showError('Enter a quantity for each location');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final order =
          await ref.read(productionOrderRepositoryProvider).createOrder(
                eliquidId: eliquid.id,
                quantity: int.tryParse(_quantityController.text.trim()),
                isPriority: _isPriority,
                allocations: allocations,
              );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ProductionOrderDetailScreen(id: order.id),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showError(e is Exception
          ? e.toString()
          : 'Something went wrong. Please try again.');
    }
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Discard new order?'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
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
                          onPressed: () async {
                            final bool shouldExit =
                                await _showExitConfirmationDialog();
                            if (shouldExit && context.mounted) {
                              Navigator.of(context).pop();
                            }
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
                    Expanded(child: SizedBox.shrink()),
                    _createOrderButton(),
                  ],
                ),
                Gap(16.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8.0),
                            ),
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 16.0,
                              ),
                              child: _selectedEliquid == null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: _addEliquidButton(),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _selectedEliquid != null
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
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
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16.0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          _selectedEliquid!
                                                                              .upc,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width: 100,
                                                                  child:
                                                                      ElTextField(
                                                                    controller:
                                                                        _quantityController,
                                                                    focusNode:
                                                                        _quantityFocusNode,
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
                                                            onPressed: () =>
                                                                _selectEliquid(
                                                                    context),
                                                            child: const Icon(
                                                              Icons
                                                                  .loop_rounded,
                                                              size: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      _addEliquidButton(),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                        Gap(16.0),
                                        Divider(
                                          thickness: 0.25,
                                        ),
                                        Gap(16.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Prioritize order',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Checkbox(
                                              value: _isPriority,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              onChanged: (b) => setState(
                                                () => _isPriority = b ?? false,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          Gap(16.0),
                          if (_selectedEliquid != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                    borderRadius:
                                        BorderRadiusGeometry.circular(8.0),
                                  ),
                                  margin: EdgeInsets.zero,
                                  child: EliquidPastOrdersPreview(
                                    eliquidId: _selectedEliquid!.id,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Gap(16.0),
                    Expanded(
                      flex: 1,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 720),
                        child: Card(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(8.0),
                          ),
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 16.0,
                            ),
                            child: _selectedLocations.isEmpty
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(
                                          8.0,
                                        ),
                                        child: _addLocationsButton(),
                                      ),
                                    ],
                                  )
                                : Column(
                                    spacing: 8.0,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ..._selectedLocations.map(
                                        (location) {
                                          return AllocationEntryRow(
                                            entry: _allocationEntry(location),
                                            onRemoved: () =>
                                                _removeAllocation(location),
                                            onQuantitySubmitted: (_) {
                                              final qty = int.tryParse(
                                                  _quantityController.text);
                                              if (qty == null ||
                                                  _totalAllocationQuantity() >
                                                      qty) {
                                                setState(() {
                                                  _quantityController.text =
                                                      _totalAllocationQuantity()
                                                          .toString();
                                                });
                                              }
                                              final keys = _allocationEntries
                                                  .keys
                                                  .toList();
                                              final currentIndex =
                                                  keys.indexOf(location.id);
                                              if (currentIndex + 1 <
                                                  keys.length) {
                                                _allocationEntries[
                                                        keys[currentIndex + 1]]!
                                                    .focusNode
                                                    .requestFocus();
                                              }
                                            },
                                          );
                                        },
                                      ),
                                      Gap(12.0),
                                      _addLocationsButton(),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
