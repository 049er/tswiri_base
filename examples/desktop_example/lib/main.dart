import 'dart:developer';
import 'package:desktop_example/views/barcodes/barcodes_view.dart';
import 'package:desktop_example/views/containers/containers/containers_view.dart';
import 'package:desktop_example/views/devices/devices_view.dart';
import 'package:desktop_example/views/gallery/gallery_view.dart';
import 'package:desktop_example/views/grids/grids_view.dart';
import 'package:desktop_example/views/search/search_view.dart';
import 'package:desktop_example/views/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tswiri_base/models/search/shopping_cart.dart';
import 'package:tswiri_base/settings/desktop_settings.dart';
import 'package:tswiri_base/theme/theme.dart';
import 'package:tswiri_base/colors/colors.dart';
import 'package:tswiri_database/desktop_database.dart';
import 'package:tswiri_database/export.dart';
import 'package:tswiri_database/functions/create_functions.dart';
import 'package:tswiri_database/test_functions/populate_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Load desktop settings.
  await loadDesktopSettings();

  //Initiate Isar Storage Directories.
  await initiateIsarDirectory();
  await initiatePhotoStorage();

  //Initiate Isar.
  isar = initiateDesktopIsar();

  //Populate the database for testing.
  createBasicContainerTypes();
  populateDatabase();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ShoppingCart(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tswiri Desktop Example',
      theme: tswiriTheme,
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  double groupAligment = -1.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _navigationRail(),
        const VerticalDivider(thickness: 1, width: 1),
        // This is the main content.

        pages[_selectedIndex],
      ],
    );
  }

  List<Widget> pages = [
    const SearchView(),
    const ContainersView(),
    const GalleryView(),
    const GridsView(),
    const DevicesView(),
    const BarcodesView(),
    const SettingsView(),
  ];

  Widget _navigationRail() {
    return NavigationRail(
      backgroundColor: background[400],
      selectedIndex: _selectedIndex,
      groupAlignment: groupAligment,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
          log(_selectedIndex.toString());
        });
      },
      labelType: labelType,
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(Icons.search),
          selectedIcon: Icon(Icons.search),
          label: Text('Search'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.account_tree_sharp),
          selectedIcon: Icon(Icons.account_tree_sharp),
          label: Text('Containers'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.devices),
          selectedIcon: Icon(Icons.devices),
          label: Text('Devices'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.photo),
          selectedIcon: Icon(Icons.photo),
          label: Text('Gallery'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.grid_on_sharp),
          selectedIcon: Icon(Icons.grid_on_sharp),
          label: Text('Grids'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.qr_code),
          selectedIcon: Icon(Icons.qr_code),
          label: Text('Barcodes'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }
}
