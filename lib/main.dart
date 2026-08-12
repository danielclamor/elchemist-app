import 'dart:io';

// import 'package:elchemist_app/constants.dart';
import 'package:elchemist_app/models/formula.dart';
import 'package:elchemist_app/models/nic_base_option.dart';
import 'package:elchemist_app/services/api_service.dart';
import 'package:elchemist_app/services/local_service.dart';
import 'package:elchemist_app/views/diy_mix_view.dart';
import 'package:elchemist_app/views/formula_list_view.dart';
import 'package:elchemist_app/views/search_mix_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  await initHiveForFlutter();

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

  List<Formula> formulas = (await ApiService().getFormulas())
      .map((formulaDto) => Formula.fromDto(formulaDto))
      .toList();

  List<NicBaseOption> nicBaseOptions = (await ApiService().getNicBaseOptions())
      .map((o) => NicBaseOption.fromDto(o))
      .toList();

  runApp(MyApp(
    formulas: formulas,
    nicBaseOptions: nicBaseOptions,
  ));
}

class MyApp extends StatelessWidget {
  final List<Formula> formulas;
  final List<NicBaseOption> nicBaseOptions;

  const MyApp(
      {super.key, required this.formulas, required this.nicBaseOptions});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0E76BD),
      brightness: Brightness.dark,
      contrastLevel: 1,
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    );
    return MaterialApp(
      title: 'ELChemist',
      theme: ThemeData(
        colorScheme: colorScheme,
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ).apply(
          bodyColor: const Color(0xFFDCDCDC),
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'ELChemist',
        formulas: formulas,
        nicBaseOptions: nicBaseOptions,
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context).textScaler.clamp(
                  minScaleFactor: 1,
                  maxScaleFactor: 2.5,
                ),
          ),
          child: child!,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.formulas,
    required this.nicBaseOptions,
  });

  final List<Formula> formulas;
  final List<NicBaseOption> nicBaseOptions;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static late List<Widget> _widgetOptions;

  static late List<BottomNavigationBarItem> bottomNavigationBarItems;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      const DiyMixView(),
      SearchMixView(
        formulas: widget.formulas,
        nicBaseOptions: widget.nicBaseOptions,
      ),
      FormulaListView(
        formulas: widget.formulas,
        nicBaseOptions: widget.nicBaseOptions,
      ),
    ];

    bottomNavigationBarItems = const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.build),
        label: 'DIY',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.science),
        label: 'Search and Mix',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: 'Formulas',
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
