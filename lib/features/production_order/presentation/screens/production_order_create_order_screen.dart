import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/features/eliquid/domain/eliquid.dart';
import 'package:elchemist_app/features/location/domain/location.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/dialogs/production_order_add_eliquid_to_order_dialog.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/dialogs/production_order_add_locations_to_order_dialog.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/eliquid_past_orders_preview.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// TODO fix layout

class ProductionOrderCreateOrderScreen extends StatefulWidget {
  const ProductionOrderCreateOrderScreen({super.key});

  @override
  State<ProductionOrderCreateOrderScreen> createState() =>
      _ProductionOrderCreateOrderScreenState();
}

class _ProductionOrderCreateOrderScreenState
    extends State<ProductionOrderCreateOrderScreen> {
  EliquidSummary? _selectedEliquid;

  List<LocationSummary> _selectedLocations = [];

  bool _isPriority = false;

  void _selectEliquid() async {
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
    }
  }

  Widget _addEliquidButton() => ElevatedButton(
        onPressed: () => _selectEliquid(),
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

  Widget _addLocationsButton() => ElevatedButton(
        onPressed: () async {
          final locations = await showDialog<List<LocationSummary>>(
            context: context,
            builder: (_) => ProductionOrderAddLocationsToOrderDialog(
              selectedList: _selectedLocations,
            ),
          );

          if (locations != null) {
            setState(() {
              _selectedLocations = locations;
            });
          }
        },
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
        ),
        child: Text(
          "+ Location",
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
        onPressed: _selectedEliquid != null ? () {} : null,
        child: Text("Create"),
      );

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
                                                            onPressed: () =>
                                                                _selectEliquid(),
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
                                          height: 0.0,
                                          thickness: 0.25,
                                          color: Colors.grey.shade500,
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
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        location.name,
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                    Gap(16.0),
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
                                              ),
                                              Gap(8.0),
                                              Expanded(
                                                flex: 0,
                                                child: SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      minimumSize: Size.zero,
                                                      shape:
                                                          const CircleBorder(),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _selectedLocations
                                                            .remove(location);
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
