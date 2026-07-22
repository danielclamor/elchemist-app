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
      name: 'Black Jet Do More Freebase',
      brand: 'Black Jet',
      chilltype: ChillType.nonChilled,
      nicType: NicType.freebase,
      nicProfiles: [
        NicProfile(
          nicLevel: "0MG",
          isNewMix: false,
          targetNicStr: 0,
          targetVG: 0.6,
          targetPG: 0.4,
          nicBaseNicStr: 1.0,
          nicBaseList: [],
          flavoringList: [
            Flavoring(
              name: "TB Marbro Conc",
              percentage: 0.0425,
              isVG: false,
            ),
            Flavoring(
              name: "FA Bitter Wizard",
              percentage: 0.0015,
              isVG: false,
            ),
          ],
        ),
        NicProfile(
          nicLevel: "3MG",
          isNewMix: false,
          targetNicStr: 0.012,
          targetVG: 0.6065,
          targetPG: 0.3935,
          nicBaseNicStr: 1.0,
          nicBaseList: [
            NicBase(
              nicBase: NicBaseOption(code: "1", name: "VG S", isVG: true),
              percentage: 0.5,
            ),
            NicBase(
              nicBase: NicBaseOption(code: "2P", name: "PG F", isVG: false),
              percentage: 0.5,
            ),
          ],
          flavoringList: [
            Flavoring(
              name: "TB Marbro Conc",
              percentage: 0.0425,
              isVG: false,
            ),
            Flavoring(
              name: "FA Bitter Wizard",
              percentage: 0.0015,
              isVG: false,
            ),
          ],
        ),
        NicProfile(
          nicLevel: "6MG",
          isNewMix: false,
          targetNicStr: 0.024,
          targetVG: 0.614755,
          targetPG: 0.385245,
          nicBaseNicStr: 1.0,
          nicBaseList: [
            NicBase(
              nicBase: NicBaseOption(code: "1", name: "VG S", isVG: true),
              percentage: 0.5,
            ),
            NicBase(
              nicBase: NicBaseOption(code: "2P", name: "PG F", isVG: false),
              percentage: 0.5,
            ),
          ],
          flavoringList: [
            Flavoring(
              name: "TB Marbro Conc",
              percentage: 0.0425,
              isVG: false,
            ),
            Flavoring(
              name: "FA Bitter Wizard",
              percentage: 0.0015,
              isVG: false,
            ),
          ],
        ),
        NicProfile(
          nicLevel: "12MG",
          isNewMix: false,
          targetNicStr: 0.048,
          targetVG: 0.63026,
          targetPG: 0.36974,
          nicBaseNicStr: 1.0,
          nicBaseList: [
            NicBase(
              nicBase: NicBaseOption(code: "1", name: "VG S", isVG: true),
              percentage: 0.6,
            ),
            NicBase(
              nicBase: NicBaseOption(code: "2P", name: "PG F", isVG: false),
              percentage: 0.4,
            ),
          ],
          flavoringList: [
            Flavoring(
              name: "TB Marbro Conc",
              percentage: 0.0425,
              isVG: false,
            ),
            Flavoring(
              name: "FA Bitter Wizard",
              percentage: 0.0015,
              isVG: false,
            ),
          ],
        ),
        NicProfile(
          nicLevel: "18MG",
          isNewMix: false,
          targetNicStr: 0.072,
          targetVG: 0.64655,
          targetPG: 0.35345,
          nicBaseNicStr: 1.0,
          nicBaseList: [
            NicBase(
              nicBase: NicBaseOption(code: "1", name: "VG S", isVG: true),
              percentage: 0.7,
            ),
            NicBase(
              nicBase: NicBaseOption(code: "2P", name: "PG F", isVG: false),
              percentage: 0.3,
            ),
          ],
          flavoringList: [
            Flavoring(
              name: "TB Marbro Conc",
              percentage: 0.0425,
              isVG: false,
            ),
            Flavoring(
              name: "FA Bitter Wizard",
              percentage: 0.0015,
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
          nicLevel: "0MG",
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
          nicLevel: "10MG",
          isNewMix: true,
          targetNicStr: 0.01,
          targetVG: 0.40,
          targetPG: 0.60,
          nicBaseNicStr: 0.1,
          nicBaseList: [
            NicBase(
              nicBase: NicBaseOption(
                code: "2CNT",
                name: "PG S",
                isVG: false,
              ),
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
          nicLevel: "20MG",
          isNewMix: true,
          targetNicStr: 0.02,
          targetVG: 0.40,
          targetPG: 0.60,
          nicBaseNicStr: 0.1,
          nicBaseList: [
            NicBase(
              nicBase: NicBaseOption(
                code: "2CNT",
                name: "PG S",
                isVG: false,
              ),
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
    Recipe(
      name: 'This Bru Da Bears Freebase',
      brand: 'This Bru MFG',
      chilltype: ChillType.nonChilled,
      nicType: NicType.freebase,
      nicProfiles: [
        NicProfile(
          nicLevel: "3MG",
          isNewMix: true,
          targetNicStr: 0.003,
          targetVG: 0.69635,
          targetPG: 0.30365,
          nicBaseNicStr: 0.1,
          nicBaseList: [
            NicBase(
              nicBase: NicBaseOption(code: "1CNT", name: "VG S", isVG: true),
              percentage: 1.0,
            )
          ],
          flavoringList: [
            Flavoring(
              name: "TB Da Bears Conc",
              percentage: 0.193,
              isVG: false,
            ),
          ],
        ),
        NicProfile(
          nicLevel: "6MG",
          isNewMix: true,
          targetNicStr: 0.006,
          targetVG: 0.692625,
          targetPG: 0.307375,
          nicBaseNicStr: 0.1,
          nicBaseList: [
            NicBase(
              nicBase: NicBaseOption(code: "1CNT", name: "VG S", isVG: true),
              percentage: 1.0,
            )
          ],
          flavoringList: [
            Flavoring(
              name: "TB Da Bears Conc",
              percentage: 0.193,
              isVG: false,
            ),
          ],
        ),
        NicProfile(
          nicLevel: "12MG",
          isNewMix: true,
          targetNicStr: 0.012,
          targetVG: 0.68487,
          targetPG: 0.31513,
          nicBaseNicStr: 0.1,
          nicBaseList: [
            NicBase(
              nicBase: NicBaseOption(code: "1CNT", name: "VG S", isVG: true),
              percentage: 1.0,
            )
          ],
          flavoringList: [
            Flavoring(
              name: "TB Da Bears Conc",
              percentage: 0.193,
              isVG: false,
            ),
          ],
        ),
      ],
    ),
    Recipe(
      name: 'Vibe Arctic Mint (Iced) Salt',
      brand: 'Vibe',
      chilltype: ChillType.chilled,
      nicType: NicType.salt,
      nicProfiles: [
        NicProfile(
          nicLevel: "10MG",
          isNewMix: false,
          targetNicStr: 0.04,
          targetVG: 0.35,
          targetPG: 0.65,
          nicBaseNicStr: 1,
          nicBaseList: [
            NicBase(
              nicBase: NicBaseOption(
                code: "1",
                name: "VG S",
                isVG: true,
              ),
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
          nicLevel: "20MG",
          isNewMix: false,
          targetNicStr: 0.08,
          targetVG: 0.35,
          targetPG: 0.65,
          nicBaseNicStr: 1.0,
          nicBaseList: [
            NicBase(
              nicBase: NicBaseOption(
                code: "1",
                name: "VG S",
                isVG: true,
              ),
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
          nicLevel: "10MG",
          isNewMix: true,
          targetNicStr: 0.01,
          targetVG: 0.35,
          targetPG: 0.65,
          nicBaseNicStr: 0.1,
          nicBaseList: [
            NicBase(
              nicBase: NicBaseOption(
                code: "1CNT",
                name: "VG S",
                isVG: false,
              ),
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
          nicLevel: "20MG",
          isNewMix: true,
          targetNicStr: 0.02,
          targetVG: 0.35,
          targetPG: 0.65,
          nicBaseNicStr: 0.1,
          nicBaseList: [
            NicBase(
              nicBase: NicBaseOption(
                code: "1CNT",
                name: "VG S",
                isVG: false,
              ),
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
  ];

  int _selectedIndex = 0;

  static late List<Widget> _widgetOptions;

  static late List<BottomNavigationBarItem> bottomNavigationBarItems;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      const DiyMixView(),
      MixView(recipes: recipes),
      RecipeListView(recipes: recipes),
    ];

    bottomNavigationBarItems = const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.science),
        label: 'DIY',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.manage_search),
        label: 'Search and Mix',
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
