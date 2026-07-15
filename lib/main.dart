import 'package:elchemist_app/components/molecules/recipe_card.dart';
import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/models/recipe.dart';
import 'package:elchemist_app/models/nic_profile.dart';
import 'package:elchemist_app/views/mix_view.dart';
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
      // home: const MyHomePage(title: 'Elchemist'),
      home: MixView(
        recipe: Recipe(
          name: 'Slice Big Island (Iced) Salt',
          brand: 'Slice',
          chilltype: ChillType.chilled,
          nicType: NicType.salt,
          nicProfiles: [
            NicProfile(
              name: "0MG",
              isNewMix: true,
              targetNicStr: 0.0,
              targetVG: 0.40,
              targetPG: 0.60,
              nicBaseStr: 0.1,
              nicBaseList: [],
              flavoringList: [
                Flavoring(
                  name: "Slice Big Island (Iced) Conc",
                  percentage: 0.225,
                  isVG: false,
                ),
              ],
            ),
            NicProfile(
              name: "10MG",
              isNewMix: true,
              targetNicStr: 0.01,
              targetVG: 0.40,
              targetPG: 0.60,
              nicBaseStr: 0.1,
              nicBaseList: [
                NicBase(
                  code: "2CNT",
                  name: "PG S",
                  isVg: false,
                  percentage: 1.0,
                ),
              ],
              flavoringList: [
                Flavoring(
                  name: "Slice Big Island (Iced) Conc",
                  percentage: 0.225,
                  isVG: false,
                ),
              ],
            ),
            NicProfile(
              name: "20MG",
              isNewMix: true,
              targetNicStr: 0.02,
              targetVG: 0.40,
              targetPG: 0.60,
              nicBaseStr: 0.1,
              nicBaseList: [
                NicBase(
                  code: "2CNT",
                  name: "PG S",
                  isVg: false,
                  percentage: 1,
                ),
              ],
              flavoringList: [
                Flavoring(
                  name: "Slice Big Island (Iced) Conc",
                  percentage: 0.225,
                  isVG: false,
                ),
              ],
            ),
          ],
        ),
      ),
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
      name: 'VIBE ARCTIC MINT (ICED) SALT',
      brand: 'VIBE',
      chilltype: ChillType.chilled,
      nicType: NicType.salt,
      nicProfiles: [
        NicProfile(
          name: "10MG",
          isNewMix: false,
          targetNicStr: 0.04,
          targetVG: 0.35,
          targetPG: 0.65,
          nicBaseStr: 1,
          nicBaseList: [
            NicBase(
              code: "1",
              name: "VG S",
              isVg: true,
              percentage: 1,
            ),
          ],
          flavoringList: [
            Flavoring(
              name: "Vibe Arctic Mint (Iced) Conc",
              percentage: 0.145,
              isVG: false,
            ),
          ],
        ),
        NicProfile(
          name: "20MG",
          isNewMix: false,
          targetNicStr: 0.08,
          targetVG: 0.35,
          targetPG: 0.65,
          nicBaseStr: 1,
          nicBaseList: [
            NicBase(
              code: "1",
              name: "VG S",
              isVg: true,
              percentage: 1,
            ),
          ],
          flavoringList: [
            Flavoring(
              name: "Vibe Arctic Mint (Iced) Conc",
              percentage: 0.145,
              isVG: false,
            ),
          ],
        )
      ],
    ),
    Recipe(
      name: 'VIBE GREEN NRG (ICED) SALT',
      brand: 'VIBE',
      chilltype: ChillType.chilled,
      nicType: NicType.salt,
      nicProfiles: [
        NicProfile(
          name: "10MG",
          isNewMix: true,
          targetNicStr: 0.01,
          targetVG: 0.35,
          targetPG: 0.65,
          nicBaseStr: 0.01,
          nicBaseList: [
            NicBase(
              code: "1CNT",
              name: "VG S",
              isVg: false,
              percentage: 1,
            ),
          ],
          flavoringList: [
            Flavoring(
              name: "Vibe Green NRG (Iced) Conc",
              percentage: 0.335,
              isVG: false,
            ),
          ],
        ),
        NicProfile(
          name: "20MG",
          isNewMix: true,
          targetNicStr: 0.02,
          targetVG: 0.35,
          targetPG: 0.65,
          nicBaseStr: 0.01,
          nicBaseList: [
            NicBase(
              code: "1CNT",
              name: "VG S",
              isVg: false,
              percentage: 1,
            ),
          ],
          flavoringList: [
            Flavoring(
              name: "Vibe Green NRG (Iced) Conc",
              percentage: 0.335,
              isVG: false,
            ),
          ],
        ),
      ],
    ),
    Recipe(
      name: 'SLICE BIG ISLAND (ICED) SALT',
      brand: 'SLICE',
      chilltype: ChillType.chilled,
      nicType: NicType.salt,
      nicProfiles: [
        NicProfile(
          name: "10MG",
          isNewMix: true,
          targetNicStr: 0.01,
          targetVG: 0.40,
          targetPG: 0.60,
          nicBaseStr: 0.01,
          nicBaseList: [
            NicBase(
              code: "2CNT",
              name: "PG ",
              isVg: false,
              percentage: 1,
            ),
          ],
          flavoringList: [
            Flavoring(
              name: "Slice Big Island (Iced) Conc",
              percentage: 0.225,
              isVG: false,
            ),
          ],
        ),
        NicProfile(
          name: "20MG",
          isNewMix: true,
          targetNicStr: 0.02,
          targetVG: 0.40,
          targetPG: 0.60,
          nicBaseStr: 0.01,
          nicBaseList: [
            NicBase(
              code: "2CNT",
              name: "PG ",
              isVg: false,
              percentage: 1,
            ),
          ],
          flavoringList: [
            Flavoring(
              name: "Slice Big Island (Iced) Conc",
              percentage: 0.225,
              isVG: false,
            ),
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final recipeNames = recipes.map((e) => e.name);

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
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: RecipeCard(recipe: recipe),
                            ),
                          ],
                        ),
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
