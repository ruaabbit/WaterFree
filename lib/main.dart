import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:provider/provider.dart';

import 'pages/water_free_page.dart';
import 'pages/waterfree_favorites_page.dart';
import 'utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.init();
  await FlutterDisplayMode.setHighRefreshRate();

  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaterFree',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  final pages = const [
    WaterFreePage(),
    WaterFavoritesPage(),
  ];

  final description = const [
    'WaterFree',
    'WaterFavorites',
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      if (index < pages.length) {
        _selectedIndex = index;
      }
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(description[_selectedIndex]),
      ),
      body: pages[_selectedIndex],
      drawer: SizedBox(
        width: 220,
        child: NavigationDrawer(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
          children: [
            NavigationDrawerDestination(
              icon: Icon(Icons.water),
              label: Text('WaterFree'),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.water),
              label: Text('WaterFreeFavorites'),
            ),
          ],
        ),
      ),
    );
  }
}
