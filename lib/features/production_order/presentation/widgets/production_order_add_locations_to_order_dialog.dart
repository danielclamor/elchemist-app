import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductionOrderAddLocationsToOrderDialog extends StatefulWidget {
  const ProductionOrderAddLocationsToOrderDialog({super.key});

  @override
  State<ProductionOrderAddLocationsToOrderDialog> createState() =>
      _ProductionOrderAddLocationsToOrderDialogState();
}

class _ProductionOrderAddLocationsToOrderDialogState
    extends State<ProductionOrderAddLocationsToOrderDialog> {
  final List<String> locations = [
    "32 St.",
    "Macleod",
  ];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      clipBehavior: Clip.hardEdge,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 480,
          maxHeight: 480,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border(
                  bottom: BorderSide(
                    width: 0.25,
                  ),
                ),
              ),
              child: Card(
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
                            "Select locations",
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
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: ListView.separated(
                  itemCount: locations.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 0.0,
                    thickness: 0.25,
                  ),
                  itemBuilder: (context, index) {
                    final location = locations[index];

                    return ListTile(
                      onTap: () {},
                      selected: true,
                      title: Text(location),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 4.0,
                      ),
                      trailing: Icon(
                        Icons.check_box_outline_blank_rounded,
                      ),
                    );
                  },
                ),
              ),
            ),
            Gap(16.0),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    offset: Offset(0, -4),
                  ),
                ],
                border: Border(
                  bottom: BorderSide(
                    width: 0.25,
                  ),
                ),
              ),
              child: Card(
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
                      Text("0 selected"),
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
                            child: Text("Add"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
