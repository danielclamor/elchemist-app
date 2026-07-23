import 'dart:io';

import 'package:elchemist_app/constants.dart';
import 'package:elchemist_app/models/recipe.dart';
import 'package:elchemist_app/views/diy_mix_view.dart';
import 'package:elchemist_app/views/search_mix_view.dart';
import 'package:elchemist_app/views/recipe_list_view.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 720),
      center: true,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setMinimumSize(const Size(800, 600));
      await windowManager.show();
      await windowManager.focus();
    });
  }

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
          brightness: Brightness.dark,
          contrastLevel: 0.25,
          dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
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
  List<Recipe> recipes =
      recipesData.map((recipe) => Recipe.fromMap(recipe)).toList();

  int _selectedIndex = 0;

  static late List<Widget> _widgetOptions;

  static late List<BottomNavigationBarItem> bottomNavigationBarItems;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      const DiyMixView(),
      SearchMixView(recipes: recipes),
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
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
