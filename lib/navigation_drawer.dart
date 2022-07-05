import 'package:flutter/material.dart';
import 'package:navigation_drawer_menu/navigation_drawer_state.dart';

class NavigationDrawer extends StatelessWidget {
  final Builder menuBuilder;
  final MenuMode menuMode;

  NavigationDrawer(
      {Key? key, required this.menuBuilder, required this.menuMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [if (menuMode == MenuMode.Drawer) menuBuilder.build(context)]);
}
