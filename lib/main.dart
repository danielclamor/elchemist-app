import 'package:elchemist_app/models/flavoring.dart';
import 'package:elchemist_app/models/nic_base.dart';
import 'package:elchemist_app/models/recipe.dart';
import 'package:elchemist_app/models/nic_profile.dart';
import 'package:elchemist_app/views/diy_mix_view.dart';
import 'package:elchemist_app/views/mix_view.dart';
import 'package:elchemist_app/views/recipe_list_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ELChemist',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E76BD),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ELChemist'),
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
  List<Recipe> recipes = [
    Recipe(
      name: 'Vibe Arctic Mint (Iced) Salt',
      brand: 'Vibe',
      chilltype: ChillType.chilled,
      nicType: NicType.salt,
      nicProfiles: [
        NicProfile(
          name: "10MG",
          isNewMix: false,
          targetNicStr: 0.04,
          targetVG: 0.35,
          targetPG: 0.65,
          nicBaseNicStr: 1,
          nicBaseList: [
            NicBase(
              code: "1",
              name: "VG S",
              isVG: true,
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
          nicBaseNicStr: 1.0,
          nicBaseList: [
            NicBase(
              code: "1",
              name: "VG S",
              isVG: true,
              percentage: 1.0,
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
      name: 'Vibe Green NRG (Iced) Salt',
      brand: 'Vibe',
      chilltype: ChillType.chilled,
      nicType: NicType.salt,
      nicProfiles: [
        NicProfile(
          name: "10MG",
          isNewMix: true,
          targetNicStr: 0.01,
          targetVG: 0.35,
          targetPG: 0.65,
          nicBaseNicStr: 0.1,
          nicBaseList: [
            NicBase(
              code: "1CNT",
              name: "VG S",
              isVG: false,
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
          nicBaseNicStr: 0.1,
          nicBaseList: [
            NicBase(
              code: "1CNT",
              name: "VG S",
              isVG: false,
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
          nicBaseNicStr: 0.1,
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
          nicBaseNicStr: 0.1,
          nicBaseList: [
            NicBase(
              code: "2CNT",
              name: "PG S",
              isVG: false,
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
          nicBaseNicStr: 0.1,
          nicBaseList: [
            NicBase(
              code: "2CNT",
              name: "PG S",
              isVG: false,
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

  int _selectedIndex = 0;

  static late List<Widget> _widgetOptions;

  static late List<BottomNavigationBarItem> bottomNavigationBarItems;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      MixView(recipes: recipes),
      const DiyMixView(),
      RecipeListView(recipes: recipes),
    ];

    bottomNavigationBarItems = const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.manage_search),
        label: 'Search and Mix',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.science),
        label: 'DIY',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: 'Recipes',
      ),
    ];

    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
