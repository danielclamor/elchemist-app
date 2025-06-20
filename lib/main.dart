import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/recipe.dart';
import 'package:elchemist_app/models/settings_by_nic.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elchemist',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E76BD),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Elchemist'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _recipeController;

  @override
  void initState() {
    _recipeController = TextEditingController();
    super.initState();
  }

  List<Recipe> recipes = [
    Recipe(
      name: 'VIBE ARCTIC MINT',
      brand: 'VIBE',
      nicType: NicType.salt,
      settingsByNic: [
        SettingsByNic(
          name: "default",
          nicStrength: null,
          targetVG: null,
          targetPG: null,
          nicBaseVG: null,
          nicBasePG: null,
          flavorings: [
            Flavoring(name: "ARCTIC MINT CONC", percentage: null, isVG: null),
          ],
        ),
      ],
    ),
    Recipe(
      name: 'VIBE GREEN NRG',
      brand: 'VIBE',
      nicType: NicType.salt,
      settingsByNic: [
        SettingsByNic(
          name: "default",
          nicStrength: null,
          targetVG: null,
          targetPG: null,
          nicBaseVG: null,
          nicBasePG: null,
          flavorings: [
            Flavoring(
              name: "GREEN NRG CONC",
              percentage: null,
              isVG: null,
            ),
          ],
        ),
      ],
    ),
    Recipe(
      name: 'VIBE MASTER SAUCE',
      brand: 'VIBE',
      nicType: NicType.salt,
      settingsByNic: [
        SettingsByNic(
          name: "default",
          nicStrength: null,
          targetVG: null,
          targetPG: null,
          nicBaseVG: null,
          nicBasePG: null,
          flavorings: [
            Flavoring(
              name: "MASTER SAUCE CONC",
              percentage: null,
              isVG: null,
            ),
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 48,
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _recipeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Search",
                    ),
                  ),
                  const Gap(8.0),
                  Column(
                    children: recipes.map((recipe) {
                      return Row(
                        children: [
                          Expanded(
                            child: Card(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  4.0,
                                ),
                              ),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      recipe.name,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      recipe.brand,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
