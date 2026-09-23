import 'dart:io';

// import 'package:elchemist_app/constants.dart';
import 'package:elchemist_app/features/production_order/presentation/screens/production_order_list_screen.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  List<Formula> formulas = (LocalService().getFormulas())
      .map((formulaDto) => Formula.fromDto(formulaDto))
      .toList();
  // List<Formula> formulas = (kDebugMode
  //         ? LocalService().getFormulas()
  //         : await ApiService().getFormulas())
  //     .map((formulaDto) => Formula.fromDto(formulaDto))
  //     .toList();

  List<NicBaseOption> nicBaseOptions = (LocalService().getNicBaseOptions())
      .map((o) => NicBaseOption.fromDto(o))
      .toList();
  // List<NicBaseOption> nicBaseOptions = (kDebugMode
  //         ? LocalService().getNicBaseOptions()
  //         : await ApiService().getNicBaseOptions())
  //     .map((o) => NicBaseOption.fromDto(o))
  //     .toList();

  runApp(
    ProviderScope(
      child: MyApp(
        formulas: formulas,
        nicBaseOptions: nicBaseOptions,
      ),
    ),
  );
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
  static late List<String> _drawerItems;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      ProductionOrderListScreen(),
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

    _drawerItems = [
      "Production Orders",
      "DIY",
      "Search & Mix",
      "Formulas",
    ];

    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const double _breakpoint = 800;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _breakpoint;

        if (isWide) {
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
            body: Row(
              children: [
                SizedBox(
                  width: 280,
                  child: Material(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withAlpha(175),
                    elevation: 1,
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 16.0,
                      ),
                      children: _drawerItems
                          .map(
                            (item) => ListTile(
                              title: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () => _onItemTapped(
                                _drawerItems.indexOf(item),
                              ),
                              selected:
                                  _selectedIndex == _drawerItems.indexOf(item),
                              selectedTileColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusGeometry.circular(8.0),
                              ),
                              visualDensity: VisualDensity.compact,
                              minTileHeight: 0.0,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
              ],
            ),
          );
        }

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
          drawer: Drawer(
            shape: RoundedRectangleBorder(),
            child: ListView(
              padding: EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 16.0,
              ),
              children: _drawerItems
                  .map(
                    (item) => ListTile(
                      title: Text(
                        item,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        _onItemTapped(
                          _drawerItems.indexOf(item),
                        );
                        Navigator.pop(context);
                      },
                      selected: _selectedIndex == _drawerItems.indexOf(item),
                      selectedTileColor: Colors.blueGrey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8.0),
                      ),
                      visualDensity: VisualDensity.compact,
                      minTileHeight: 0.0,
                    ),
                  )
                  .toList(),
            ),
          ),
          body: _widgetOptions.elementAt(_selectedIndex),
        );
      },
    );
  }
}
