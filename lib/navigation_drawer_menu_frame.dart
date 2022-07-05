import 'package:flutter/material.dart';
import 'package:navigation_drawer_menu/navigation_drawer_state.dart';

///Set the body of your [Scaffold] to this. It will put the menu
///to the left of your page body and the page body to the right.
class NavigationDrawerMenuFrame extends StatelessWidget {
  final MenuMode menuMode;
  final Color menuBackgroundColor;
  final Widget body;
  final Builder menuBuilder;
  final double? thinMenuWidth;
  final double? thickMenuWidth;

  NavigationDrawerMenuFrame(
      {required this.menuMode,
      required this.menuBackgroundColor,
      required this.body,
      required this.menuBuilder,
      this.thinMenuWidth = 60,
      this.thickMenuWidth = 200});

  @override
  Widget build(BuildContext context) => Row(children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (menuMode != MenuMode.Drawer)
            SizedBox(
                width:
                    menuMode == MenuMode.Thin ? thinMenuWidth : thickMenuWidth,
                child: Container(
                    color: menuBackgroundColor,
                    child: menuBuilder.build(context))),
        ]),
        Expanded(child: body)
      ]);
}
