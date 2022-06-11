import 'package:flutter/material.dart';
import 'package:navigation_drawer_menu/navigation_drawer_menu.dart';

enum MenuMode { Drawer, Thin, Thick }

class NavigationDrawerScaffold extends StatefulWidget {
  final String? title;
  final Key initialMenuItemKey;
  final Color? menuColor;
  final List<MenuItemContent> menuItems;
  final double? minimumWidthForThickMenu;
  final double? minimumWidthForMenu;
  final PreferredSizeWidget Function(Function() toggle) getAppBar;

  const NavigationDrawerScaffold(
      {Key? key,
      required this.initialMenuItemKey,
      required this.menuItems,
      this.title,
      this.menuColor,
      this.minimumWidthForThickMenu,
      this.minimumWidthForMenu,

      ///Is this OK? The widget might get old...
      required this.getAppBar})
      : super(key: key);

  @override
  State<NavigationDrawerScaffold> createState() =>
      _NavigationDrawerScaffoldState(
          title ?? 'Menu',
          initialMenuItemKey,
          menuColor ?? Colors.black,
          menuItems,
          minimumWidthForMenu ?? 500,
          minimumWidthForThickMenu ?? 700,
          getAppBar);
}

class _NavigationDrawerScaffoldState extends State<NavigationDrawerScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final ValueNotifier<Key> valueNotifier;
  bool isThin = false;
  String title;
  Color menuColor;
  final List<MenuItemContent> menuItems;
  final double minimumWidthForThickMenu;
  final double minimumWidthForMenu;
  final PreferredSizeWidget Function(Function() toggle) getAppBar;

  _NavigationDrawerScaffoldState(
      this.title,
      Key initialKey,
      this.menuColor,
      this.menuItems,
      this.minimumWidthForMenu,
      this.minimumWidthForThickMenu,
      this.getAppBar) {
    valueNotifier = ValueNotifier<Key>(initialKey);
  }

  MenuMode getMenuMode(bool isThin, BuildContext cont) {
    final width = MediaQuery.of(cont).size.width;
    if (width > minimumWidthForThickMenu) {
      return !isThin ? MenuMode.Thick : MenuMode.Thin;
    }
    if (width <= minimumWidthForMenu) {
      return MenuMode.Drawer;
    }
    return MenuMode.Thin;
  }

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

  void toggle() {
    isThin = !isThin;
    toggleDrawer(getMenuMode(isThin, context));
  }

  @override
  Widget build(BuildContext cont) {
    return Builder(builder: (context) {
      if (getMenuMode(isThin, context) != MenuMode.Drawer) {
        _scaffoldKey.currentState?.openEndDrawer();
      }

      return Scaffold(
          key: _scaffoldKey,
          appBar: getAppBar(toggle),
          drawer: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (getMenuMode(isThin, context) == MenuMode.Drawer)
                  getMenu(context)
              ]),
          body: Container(
              color: menuColor,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (getMenuMode(isThin, context) != MenuMode.Drawer)
                      SizedBox(
                          width: getMenuMode(isThin, context) == MenuMode.Thin
                              ? 60
                              : 200,
                          child: Container(
                              color: menuColor, child: getMenu(context)))
                  ])));
    });
  }

  NavigationDrawerMenu getMenu(BuildContext context) => NavigationDrawerMenu(
      getHighlightColor: () => Theme.of(context).indicatorColor,
      onSelectionChanged: (key) => toggleDrawer(getMenuMode(isThin, context)),
      menuItemContentList: ValueNotifier(menuItems),
      selectedMenuKey: valueNotifier,
      itemHeight: 60,
      itemPadding: const EdgeInsets.only(left: 5, right: 5),
      buildMenuButtonContent: (mbd, isSelected, bc) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: getMenuMode(isThin, context) != MenuMode.Thin
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
