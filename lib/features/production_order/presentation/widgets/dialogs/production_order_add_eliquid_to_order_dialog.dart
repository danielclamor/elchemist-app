import 'package:elchemist_app/features/eliquid/domain/eliquid.dart';
import 'package:elchemist_app/features/eliquid/presentation/widgets/eliquid_picker_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductionOrderAddEliquidToOrderDialog extends StatefulWidget {
  const ProductionOrderAddEliquidToOrderDialog({super.key});

  @override
  State<ProductionOrderAddEliquidToOrderDialog> createState() =>
      _ProductionOrderAddEliquidToOrderDialogState();
}

class _ProductionOrderAddEliquidToOrderDialogState
    extends State<ProductionOrderAddEliquidToOrderDialog> {
  EliquidSummary? _selected;
  bool get _selectionFilled => _selected != null;

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
                          "Select e-liquid",
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
                child: EliquidPickerList(
                  selectedId: _selected?.id,
                  onSelected: (eliquid) => setState(() {
                    _selected = _selected?.id == eliquid.id ? null : eliquid;
                  }),
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
                    Text('${_selectionFilled ? '1' : '0'}/1 selected'),
                    Row(
                      spacing: 8.0,
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
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0E76BD),
                            side: _selectionFilled
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
                          onPressed: _selectionFilled
                              ? () => Navigator.of(context).pop(_selected)
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
