import 'package:flutter/material.dart';
import 'package:navigation_drawer_menu/navigation_drawer.dart';
import 'package:navigation_drawer_menu/navigation_drawer_menu.dart';
import 'package:navigation_drawer_menu/navigation_drawer_menu_frame.dart';
import 'package:navigation_drawer_menu/navigation_drawer_state.dart';

enum MenuMode { Drawer, Thin, Thick }

const alarmValueKey = ValueKey('Alarm');
const todoValueKey = ValueKey('Todo');
const photoValueKey = ValueKey('Photo');

final Map<Key, MenuItemContent> menuItems = {
  alarmValueKey: MenuItemContent(
      MenuItemDefinition("Alarm", alarmValueKey, iconData: Icons.access_alarm)),
  todoValueKey: MenuItemContent(MenuItemDefinition("Todo", todoValueKey,
      iconData: Icons.ad_units_rounded)),
  photoValueKey: MenuItemContent(MenuItemDefinition("Photo", photoValueKey,
      iconData: Icons.add_a_photo_outlined))
};

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueKey<String> selectedMenuKey = alarmValueKey;
  final NavigationDrawerState state = NavigationDrawerState();

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
        home: Builder(builder: (context) {
          if (state.menuMode(cont) != MenuMode.Drawer) {
            _scaffoldKey.currentState?.openEndDrawer();
          }

          return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: const Text(title),
                leading: Builder(
                    builder: (context) => IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => state.toggle(context),
                          tooltip: 'Toggle the menu',
                        )),
              ),
              drawer: NavigationDrawer(
                menuBuilder: Builder(builder: getMenu),
                menuMode: state.menuMode(cont),
              ),
              body: NavigationDrawerMenuFrame(
                body: Builder(
                    builder: (c) =>
                        Icon(menuItems[selectedMenuKey]!.menuItem!.iconData)),
                menuBackgroundColor: menuColor,
                menuBuilder: Builder(builder: getMenu),
                menuMode: state.menuMode(context),
              ));
        }));
  }

  NavigationDrawerMenu getMenu(BuildContext context) => NavigationDrawerMenu(
      highlightColor: Theme.of(context).indicatorColor,
      onSelectionChanged: (c, key) => selectedMenuKey = key,
      menuItems: menuItems.values.toList(),
      selectedMenuKey: selectedMenuKey,
      itemHeight: 60,
      itemPadding: const EdgeInsets.only(left: 5, right: 5),
      buildMenuButtonContent: (mbd, isSelected, bc) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: state.menuMode(context) != MenuMode.Thin
              ? [
                  getIcon(mbd, isSelected, bc),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(mbd.text,
                      style: isSelected
                          ? Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Theme.of(bc).backgroundColor)
                          : Theme.of(bc).textTheme.bodyText2)
                ]
              : [getIcon(mbd, isSelected, bc)]));

  Icon getIcon(MenuItemDefinition mbd, bool isSelected, BuildContext bc) =>
      Icon(mbd.iconData,
          color: isSelected
              ? Theme.of(bc).backgroundColor
              : Theme.of(bc).textTheme.bodyText2!.color);
}
