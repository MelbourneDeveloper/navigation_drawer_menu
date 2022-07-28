import 'package:flutter/material.dart';

///Drawer: small screens like phones and tablets
///Thin: menu display is thin (icon only)
///Thick: menu display is thick (icon and text)
enum MenuMode { drawer, thin, thick }

enum _MenuThickness { thick, thin }

///The state of the navigation drawer. Control the drawer
///here and use [menuMode] to get the mode.
///Your app should only have one of these and you need
///to keep track of it globally.
class NavigationDrawerState {
  final double minimumThickMenuWidth;
  final double minimumMenuWidth;
  Key? selectedMenuKey;
  _MenuThickness _menuThickness = _MenuThickness.thick;

  NavigationDrawerState({
    this.minimumThickMenuWidth = 700,
    this.minimumMenuWidth = 500,
  });

  MenuMode menuMode(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width > minimumThickMenuWidth) {
      return _menuThickness == _MenuThickness.thick
          ? MenuMode.thick
          : MenuMode.thin;
    }

    if (width <= minimumMenuWidth) {
      return MenuMode.drawer;
    }

    return MenuMode.thin;
  }

  void toggle(BuildContext context) {
    _menuThickness = _menuThickness == _MenuThickness.thick
        ? _MenuThickness.thin
        : _MenuThickness.thick;
    _toggleDrawer(context);
  }

  void closeDrawer(BuildContext context) {
    if (Scaffold.of(context).isDrawerOpen) {
      Scaffold.of(context).openEndDrawer();
    }
  }

  void _toggleDrawer(BuildContext context) {
    if (menuMode(context) == MenuMode.drawer) {
      if (Scaffold.of(context).isDrawerOpen) {
        Scaffold.of(context).openEndDrawer();
      } else {
        Scaffold.of(context).openDrawer();
      }
    }
  }
}
