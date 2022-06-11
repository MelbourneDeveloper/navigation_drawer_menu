import 'package:flutter/material.dart';
import 'package:navigation_drawer_menu/navigation_drawer_menu.dart';

enum MenuMode { Drawer, Thin, Thick }

class NavigationDrawerScaffold extends StatefulWidget {
  /// The current menu index, and the mechanism for listening to the change of
  /// the index externally
  final ValueNotifier<Key?> selectedMenuKey;
  final Color? menuColor;
  final List<MenuItemContent> menuItems;
  final double? minimumWidthForThickMenu;
  final double? minimumWidthForMenu;
  final PreferredSizeWidget Function(Function() toggle) getAppBar;
  final Widget Function() getBody;

  const NavigationDrawerScaffold(
      {Key? key,
      required this.selectedMenuKey,
      required this.menuItems,
      required this.getBody,
      this.menuColor,
      this.minimumWidthForThickMenu,
      this.minimumWidthForMenu,

      ///Is this OK? The widget might get old...
      required this.getAppBar})
      : super(key: key);

  @override
  State<NavigationDrawerScaffold> createState() =>
      _NavigationDrawerScaffoldState(
          selectedMenuKey,
          menuColor ?? Colors.black,
          menuItems,
          minimumWidthForMenu ?? 500,
          minimumWidthForThickMenu ?? 700,
          getAppBar,
          getBody);
}

class _NavigationDrawerScaffoldState extends State<NavigationDrawerScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isThin = false;

  Color menuColor;
  //TODO: How do we know when these change?
  final List<MenuItemContent> menuItems;
  final double minimumWidthForThickMenu;
  final double minimumWidthForMenu;
  final PreferredSizeWidget Function(Function() toggle) getAppBar;
  final Widget Function() getBody;
  final ValueNotifier<Key?> selectedMenuKey;

  _NavigationDrawerScaffoldState(
      this.selectedMenuKey,
      this.menuColor,
      this.menuItems,
      this.minimumWidthForMenu,
      this.minimumWidthForThickMenu,
      this.getAppBar,
      this.getBody);

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
    _isThin = !_isThin;
    toggleDrawer(getMenuMode(_isThin, context));
  }

  @override
  Widget build(BuildContext cont) {
    return Builder(builder: (context) {
      if (getMenuMode(_isThin, context) != MenuMode.Drawer) {
        _scaffoldKey.currentState?.openEndDrawer();
      }

      return Scaffold(
          key: _scaffoldKey,
          appBar: getAppBar(toggle),
          drawer: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (getMenuMode(_isThin, context) == MenuMode.Drawer)
                  getMenu(context)
              ]),
          body: Container(
              color: menuColor,
              child: Row(children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  if (getMenuMode(_isThin, context) != MenuMode.Drawer)
                    SizedBox(
                        width: getMenuMode(_isThin, context) == MenuMode.Thin
                            ? 60
                            : 200,
                        child: Container(
                            color: menuColor, child: getMenu(context))),
                ]),
                Expanded(child: getBody())
              ])));
    });
  }

  NavigationDrawerMenu getMenu(BuildContext context) => NavigationDrawerMenu(
      getHighlightColor: () => Theme.of(context).indicatorColor,
      onSelectionChanged: (key) => toggleDrawer(getMenuMode(_isThin, context)),
      menuItemContentList: ValueNotifier(menuItems),
      selectedMenuKey: selectedMenuKey,
      itemHeight: 60,
      itemPadding: const EdgeInsets.only(left: 5, right: 5),
      buildMenuButtonContent: (mbd, isSelected, bc) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: getMenuMode(_isThin, context) != MenuMode.Thin
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
