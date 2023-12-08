import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:provider/provider.dart';

import 'pages/WaterFreeFavoritesPage.dart';
import 'pages/WaterFreePage.dart';
import 'utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.init();
  await FlutterDisplayMode.setHighRefreshRate();

  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaterFree',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final pages = [
      WaterFreePage(),
      WaterFavoritesPage(),
    ];
    final description = [
      'WaterFree',
      'WaterFavorite',
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(description[_selectedIndex]),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      drawer: SizedBox(
        width: 220,
        child: NavigationDrawer(
            selectedIndex: _selectedIndex,
            children: [
              NavigationDrawerDestination(
                icon: Icon(Icons.water),
                label: Text('WaterFree'),
              ),
              NavigationDrawerDestination(
                icon: Icon(Icons.water),
                label: Text('WaterFreeFavorite'),
              ),
            ],
            onDestinationSelected: (index) {
              setState(() {
                if (index < pages.length) {
                  _selectedIndex = index;
                }
              });
              Navigator.of(context).pop();
            }),
      ),
    );
  }
}
