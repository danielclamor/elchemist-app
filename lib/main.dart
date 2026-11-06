import 'dart:io';

// import 'package:elchemist_app/constants.dart';
import 'package:elchemist_app/core/widgets/nested_navigator.dart';
import 'package:elchemist_app/features/mix_batch/presentation/screens/mix_batch_list_screen.dart';
import 'package:elchemist_app/features/production_order/presentation/screens/production_order_list_screen.dart';
import 'package:elchemist_app/views/diy_mix_view.dart';
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
      fullScreen: true,
      center: true,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setMinimumSize(const Size(800, 600));
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

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
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final _productionOrdersNavKey = GlobalKey<NavigatorState>();
  final _mixBatchesNavKey = GlobalKey<NavigatorState>();

  late final List<Widget> _widgetOptions;
  late final List<String> _drawerItems;

  @override
  void initState() {
    super.initState();

    _widgetOptions = <Widget>[
      NestedNavigator(
        navigatorKey: _productionOrdersNavKey,
        root: ProductionOrderListScreen(),
      ),
      NestedNavigator(
        navigatorKey: _mixBatchesNavKey,
        root: MixBatchListScreen(),
      ),
      const DiyMixView(),
    ];

    _drawerItems = [
      "Production Orders",
      "Mix Batches",
      "DIY",
    ];
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _widgetOptions,
                  ),
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
