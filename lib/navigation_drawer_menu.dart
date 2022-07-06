import 'package:flutter/material.dart';
import 'package:navigation_drawer_menu/navigation_drawer.dart';

/// The definition of the Menu Item that will be rendered
@immutable
class MenuItemDefinition {
  MenuItemDefinition(this.text, this.key, {this.iconData});

  final String text;
  final ValueKey<String> key;
  final IconData? iconData;
}

/// Defines the content that will appear in the menu.
@immutable
class MenuItemContent {
  MenuItemContent({this.menuItem, this.widget})
      : assert(menuItem != null || widget != null,
            'You must specify a menu item or a widget'),
        assert(menuItem == null || widget == null,
            'You must not pecify a menu item and a widget');

  final Widget? widget;
  final MenuItemDefinition? menuItem;
}

class _MenuItem extends StatelessWidget {
  const _MenuItem(
      {Key? key,
      required this.menuButtonDefinition,
      required this.isSelected,
      required this.onPressed,
      required this.menuButtonHeight,
      required this.highlightColor,
      required this.content})
      : super(key: key);

  final Function() onPressed;
  final double menuButtonHeight;
  final Color highlightColor;
  final Widget content;
  final MenuItemDefinition menuButtonDefinition;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => SizedBox(
            height: menuButtonHeight,
            child: TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                    backgroundColor:
                        isSelected ? highlightColor : Colors.transparent),
                child: content)),
      );
}

///Vertical menu that can be used in the [NavigationDrawer]
class NavigationDrawerMenu extends StatelessWidget {
  ///Height of the menu item buttons
  final double itemHeight;

  ///Selection color for the selected menu item
  final Color highlightColor;

  ///Padding between the menu item buttons
  final EdgeInsetsGeometry itemPadding;

  ///Build the content for the menu item button based on the
  ///[MenuItemDefinition]
  final Widget Function(MenuItemDefinition menuButtonDefinition,
      bool isSelected, BuildContext context) buildMenuButtonContent;

  /// The current menu index, and the mechanism for listening to the change of
  /// the index externally
  final Key? selectedMenuKey;

  /// The list of widgets that appear in the menu
  final List<MenuItemContent> menuItems;

  ///The callback that is called when the menu item is selected
  final void Function(
          BuildContext context, ValueKey<String> selectedMenuItemKey)
      onSelectionChanged;

  NavigationDrawerMenu(
      {required this.onSelectionChanged,
      this.selectedMenuKey,
      required this.menuItems,
      Key? key,
      this.itemHeight = 60,
      required this.highlightColor,
      required this.itemPadding,
      required this.buildMenuButtonContent})
      : super(key: key);

  List<Widget> getWidgets(BuildContext context) => menuItems
      .map((element) =>
          element.widget ?? buildMenuButton(context, element.menuItem!))
      .toList();

  Widget buildMenuButton(
          BuildContext context, MenuItemDefinition menuButtonDefinition) =>
      Padding(
        padding: itemPadding,
        child: _MenuItem(
            menuButtonDefinition: menuButtonDefinition,
            menuButtonHeight: itemHeight,
            highlightColor: highlightColor,
            key: menuButtonDefinition.key,
            isSelected: selectedMenuKey == menuButtonDefinition.key,
            content: buildMenuButtonContent(menuButtonDefinition,
                selectedMenuKey == menuButtonDefinition.key, context),
            onPressed: () =>
                onSelectionChanged(context, menuButtonDefinition.key)),
      );

  @override
  Widget build(BuildContext context) => Column(children: [
        Column(
          children: getWidgets(context),
        ),
      ]);
}
