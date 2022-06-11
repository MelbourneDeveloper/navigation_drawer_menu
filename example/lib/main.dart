import 'package:flutter/material.dart';
import 'package:navigation_drawer_menu/navigation_drawer_menu.dart';
import 'package:navigation_drawer_menu/navigation_drawer_menu_scaffold.dart';

enum MenuMode { Drawer, Thin, Thick }

const alarmValueKey = ValueKey('Alarm');
const todoValueKey = ValueKey('Todo');
const photoValueKey = ValueKey('Photo');

final menuItems = [
  MenuItemContent(
      MenuItemDefinition("Alarm", alarmValueKey, iconData: Icons.access_alarm)),
  MenuItemContent(MenuItemDefinition("Todo", todoValueKey,
      iconData: Icons.ad_units_rounded)),
  MenuItemContent.widget(const SizedBox(
    height: 30,
  )),
  MenuItemContent(MenuItemDefinition("Photo", photoValueKey,
      iconData: Icons.add_a_photo_outlined))
];

const minimumWidthForMenu = 500;
const minimumWidthForThickMenu = 700;
const title = 'navigation_drawer_menu Demo';
const menuColor = Color(0xFF424242);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext cont) {
    return MaterialApp(
        title: title,
        theme: ThemeData(
            brightness: Brightness.dark,
            textTheme:
                const TextTheme(bodyText2: TextStyle(color: Color(0xFFFFFFFF))),
            primaryColor: Colors.white,
            backgroundColor: Colors.black),
        home: NavigationDrawerScaffold(
          menuItems: menuItems,
          menuColor: menuColor,
          initialMenuItemKey: alarmValueKey,
        ));
  }
}
