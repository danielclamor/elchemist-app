import 'package:elchemist_app/features/mix_session/providers/mix_session_providers.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_picker_list.dart';
import 'package:elchemist_app/features/production_order/providers/production_order_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class MixSessionAddProductionOrdersDialog extends ConsumerStatefulWidget {
  final String mixSessionId;
  final String formulaId;

  const MixSessionAddProductionOrdersDialog({
    super.key,
    required this.mixSessionId,
    required this.formulaId,
  });

  @override
  ConsumerState<MixSessionAddProductionOrdersDialog> createState() =>
      _MixSessionAddProductionOrdersDialogState();
}

class _MixSessionAddProductionOrdersDialogState
    extends ConsumerState<MixSessionAddProductionOrdersDialog> {
  final List<ProductionOrderSummary> _selectedList = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 480,
          maxHeight: 480,
        ),
        child: Column(
          children: [
            Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                  bottom: Radius.circular(0.0),
                ),
              ),
              margin: EdgeInsets.zero,
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select orders",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              shape: const CircleBorder(),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
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
                      ],
                    ),
                    Gap(16.0),
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
            ),
            Divider(
              height: 1.0,
              thickness: 0.25,
              color: Colors.black,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: ProductionOrderPickerList(
                  formulaId: widget.formulaId,
                  selectedList: _selectedList,
                  onSelected: (order) {
                    setState(() {
                      if (_selectedList.contains(order)) {
                        _selectedList.remove(order);
                      } else {
                        _selectedList.add(order);
                      }
                    });
                  },
                ),
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 0.25,
              color: Colors.black,
            ),
            Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(0.0),
                  bottom: Radius.circular(20.0),
                ),
              ),
              margin: EdgeInsets.zero,
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_selectedList.length} selected'),
                    Row(
                      spacing: 8.0,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF0E76BD),
                            textStyle: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: _selectedList.isNotEmpty
                              ? () => setState(() => _selectedList.clear())
                              : null,
                          child: Text("Clear"),
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
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0E76BD),
                            side: _selectedList.isNotEmpty
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
                          onPressed: _selectedList.isNotEmpty
                              ? () {
                                  final mixSessionId = widget.mixSessionId;
                                  try {
                                    ref
                                        .read(productionOrderRepositoryProvider)
                                        .bulkAssignToMixSession(
                                          mixSessionId: mixSessionId,
                                          productionOrderIds: _selectedList
                                              .map((o) => o.id)
                                              .toList(),
                                        );
                                    Navigator.of(context).pop();
                                    ref.invalidate(mixSessionDetailsProvider(
                                        mixSessionId));
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }
                                }
                              : null,
                          child: Text("Add"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
