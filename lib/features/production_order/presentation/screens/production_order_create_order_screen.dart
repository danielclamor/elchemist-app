import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/features/eliquid/domain/eliquid.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_add_eliquid_to_order_dialog.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/production_order_add_locations_to_order_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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

  final List<String> _selectedLocations = [
    "32 St.",
    "Macleod",
  ];

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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
