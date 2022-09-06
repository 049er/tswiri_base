import 'package:example/views/containers/containers/containers_view.dart';
import 'package:example/views/search/search_view.dart';
import 'package:example/views/settings/settings_view.dart';
import 'package:example/views/utilities/utilities_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tswiri_base/models/search/shopping_cart.dart';
import 'package:tswiri_base/settings/app_settings.dart';
import 'package:tswiri_base/theme/theme.dart';
import 'package:tswiri_database/export.dart';
import 'package:tswiri_database/functions/create_functions.dart';
import 'package:tswiri_database/mobile_database.dart';
import 'package:tswiri_database/test_functions/populate_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Force portraitUp.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  //Load app settings.
  await loadAppSettigns();

  //Initiate Isar Storage Directories.
  await initiateIsarDirectory();
  await initiatePhotoStorage();

  //Initiate Isar.
  isar = initiateMobileIsar();

  //Populate the database for testing.
  createBasicContainerTypes();
  populateDatabase();

  // log(isar!.containerRelationships.where().findAllSync().toString());

  //Run app with shoppingcart provider.
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
      title: 'Tswiri Example',
      theme: sunbirdTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  //Tab controller.
  late final TabController _tabController = TabController(
    vsync: this,
    length: 4,
    initialIndex: 1,
  );
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabBarView(),
      bottomSheet: _bottomSheet(),
    );
  }

  Widget _tabBarView() {
    return TabBarView(
      physics: isSearching ? const NeverScrollableScrollPhysics() : null,
      controller: _tabController,
      children: [
        ContainersView(
          isSearching: (value) => setState(() {
            isSearching = value;
          }),
        ),
        SearchView(
          isSearching: (value) => setState(() {
            isSearching = value;
          }),
        ),
        const UtilitiesView(),
        const SettingsView(),
      ],
    );
  }

  Widget _bottomSheet() {
    return TabBar(
      // isScrollable: !isSearching,
      controller: _tabController,
      labelPadding: const EdgeInsets.all(2.5),
      tabs: const [
        Tooltip(
          message: "Containers",
          child: Tab(
            icon: Icon(
              Icons.account_tree_sharp,
            ),
          ),
        ),
        Tooltip(
          message: "Search",
          child: Tab(
            icon: Icon(
              Icons.search_sharp,
            ),
          ),
        ),
        Tooltip(
          message: "Utilities",
          child: Tab(
            icon: Icon(Icons.build_sharp),
          ),
        ),
        Tooltip(
          message: "Settings",
          child: Tab(
            icon: Icon(
              Icons.settings_sharp,
            ),
          ),
        ),
      ],
    );
  }
}
