import 'package:flutter/material.dart';
import 'package:navigation_drawer_menu/navigation_drawer_menu.dart';

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

extension on BuildContext {
  MenuMode getMenuMode(bool isThin) {
    final width = MediaQuery.of(this).size.width;
    if (width > minimumWidthForThickMenu) {
      return !isThin ? MenuMode.Thick : MenuMode.Thin;
    }
    if (width <= minimumWidthForMenu) {
      return MenuMode.Drawer;
    }
    return MenuMode.Thin;
  }
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueKey<String> selectedMenuKey = alarmValueKey;
  bool isThin = false;

  void toggleDrawer(MenuMode menuMode) {
    if (menuMode != MenuMode.Drawer) {
      setState(() {});
    } else {
      if (_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState!.openEndDrawer();
      } else {
        _scaffoldKey.currentState!.openDrawer();
      }
    }
  }

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
          if (context.getMenuMode(isThin) != MenuMode.Drawer) {
            _scaffoldKey.currentState?.openEndDrawer();
          }

          return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: const Text(title),
                leading: Builder(
                    builder: (context) => IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            isThin = !isThin;
                            toggleDrawer(context.getMenuMode(isThin));
                          },
                          tooltip: 'Toggle the menu',
                        )),
              ),
              drawer: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (context.getMenuMode(isThin) == MenuMode.Drawer)
                      getMenu(context)
                  ]),
              body: Container(
                  color: menuColor,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (context.getMenuMode(isThin) != MenuMode.Drawer)
                          SizedBox(
                              width:
                                  context.getMenuMode(isThin) == MenuMode.Thin
                                      ? 60
                                      : 200,
                              child: Container(
                                  color: menuColor, child: getMenu(context)))
                      ])));
        }));
  }

  NavigationDrawerMenu getMenu(BuildContext context) => NavigationDrawerMenu(
      highlightColor: Theme.of(context).indicatorColor,
      onSelectionChanged: (c, key) => toggleDrawer(context.getMenuMode(isThin)),
      menuItems: menuItems,
      selectedMenuKey: selectedMenuKey,
      itemHeight: 60,
      itemPadding: const EdgeInsets.only(left: 5, right: 5),
      buildMenuButtonContent: (mbd, isSelected, bc) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: context.getMenuMode(isThin) != MenuMode.Thin
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
