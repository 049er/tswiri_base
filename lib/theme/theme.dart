import 'package:flutter/material.dart';
import 'package:tswiri_base/colors/colors.dart';

///Sunbird Theme.
ThemeData tswiriTheme = ThemeData(
  brightness: Brightness.dark,
  backgroundColor: Colors.black,
  primaryColor: tswiriOrange,

  //ColorScheme.
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: tswiriOrange,
    accentColor: background[400],
    brightness: Brightness.dark,
    backgroundColor: Colors.black,
  ),

  //AppBar Theme.
  appBarTheme: const AppBarTheme(
    backgroundColor: background,
    elevation: 10,
  ),

  //BottomSheet Theme.
  bottomSheetTheme: const BottomSheetThemeData(
    elevation: 10,
  ),

  //Scaffold Background Color.
  scaffoldBackgroundColor: background[800],

  //Button Theme.
  buttonTheme: const ButtonThemeData(
    buttonColor: tswiriOrange,
  ),

  //ElevatedButton Theme.
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: tswiriOrange,
      textStyle: const TextStyle(
        fontSize: 16,
      ),
    ),
  ),

  //Card Theme.
  cardTheme: CardTheme(
    color: background[400],
    elevation: 10,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      // side: const BorderSide(
      //   color: sunbirdOrange,
      //   width: 0.5,
      // ),
      borderRadius: BorderRadius.circular(10),
    ),
  ),

  //Container Theme

  //TextBox Theme.
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(Colors.white),
    fillColor: MaterialStateProperty.all(tswiriOrange),
  ),

  //FloatingActionButton Theme.
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Colors.white,
    backgroundColor: tswiriOrange,
  ),

  //TabBar Theme.
  tabBarTheme: TabBarTheme(
    indicator: const UnderlineTabIndicator(
      borderSide: BorderSide(
        color: tswiriOrange,
        width: 3.5,
      ),
    ),
    overlayColor: MaterialStateProperty.all(tswiriOrange),
  ),

  //Text Theme.
  textTheme: const TextTheme(
    //labelLarge.
    labelLarge: TextStyle(
      fontSize: 20,
    ),
    //labelMedium.
    labelMedium: TextStyle(
      fontSize: 17,
    ),
    //labelSmall.
    labelSmall: TextStyle(
      fontSize: 15,
    ),
    //titleLarge.
    titleLarge: TextStyle(
      fontSize: 25,
    ),
    //titleMedium.
    titleMedium: TextStyle(
      fontSize: 18,
    ),
    //titleSmall.
    titleSmall: TextStyle(
      fontSize: 16,
    ),
    //bodyLarge.
    bodyLarge: TextStyle(
      fontSize: 16,
    ),
    //headlineSmall.
    headlineSmall: TextStyle(
      fontSize: 20,
      color: tswiriOrange,
      fontWeight: FontWeight.bold,
    ),
  ),

  //TextSelection Theme.
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: tswiriOrange,
  ),

  //InputDecoration Theme.
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
  ),

  //Chip Theme.
  chipTheme: ChipThemeData(
    backgroundColor: background[300],
    selectedColor: tswiriOrange,
    shape: const StadiumBorder(
      side: BorderSide(
        color: tswiriOrange,
      ),
    ),
  ),
);
