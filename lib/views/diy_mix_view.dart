import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DiyMixView extends StatefulWidget {
  const DiyMixView({super.key});

  @override
  State<DiyMixView> createState() => _DiyMixViewState();
}

class _DiyMixViewState extends State<DiyMixView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "DIY",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      constraints:
                          const BoxConstraints(minWidth: 500, maxWidth: 500),
                      child: Column(
                        spacing: 12,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Batch",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF6CA0C4),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF0E76BD),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white60,
                              labelText: "Volume",
                              suffix: Text("mL"),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 8.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      constraints:
                          const BoxConstraints(minWidth: 500, maxWidth: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Target",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(12),
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF6CA0C4),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF0E76BD),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white60,
                              labelText: "Nic Str",
                              suffix: Text("%"),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 8.0,
                              ),
                            ),
                          ),
                          const Gap(8),
                          Row(
                            spacing: 8.0,
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF6CA0C4),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF0E76BD),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white60,
                                    labelText: "VG",
                                    suffix: Text("%"),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 8.0,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF6CA0C4),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF0E76BD),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white60,
                                    labelText: "PG",
                                    suffix: Text("%"),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 8.0,
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
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      constraints:
                          const BoxConstraints(minWidth: 500, maxWidth: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Nic Base",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(12),
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF6CA0C4),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF0E76BD),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white60,
                              labelText: "Nic Str",
                              suffix: Text("%"),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 8.0,
                              ),
                            ),
                          ),
                          const Gap(8),
                          Row(
                            spacing: 8.0,
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF6CA0C4),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF0E76BD),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white60,
                                    labelText: "VG",
                                    suffix: Text("%"),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 8.0,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF6CA0C4),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF0E76BD),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white60,
                                    labelText: "PG",
                                    suffix: Text("%"),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 8.0,
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
                ],
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  constraints:
                      const BoxConstraints(minWidth: 500, maxWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Recipe",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
