import 'package:flutter/material.dart';

@immutable
class MenuItemDefinition {
  MenuItemDefinition(this.text, this.key, {this.iconData});

  final String text;
  final ValueKey key;
  final IconData? iconData;
}

@immutable
class MenuItemContent {
  MenuItemContent(this.menuItem) {
    widget = null;
  }

  MenuItemContent.widget(this.widget) {
    menuItem = null;
  }

  late final Widget? widget;
  late final MenuItemDefinition? menuItem;
}

class _MenuItem extends StatelessWidget {
  const _MenuItem(
      {Key? key,
      required this.menuButtonDefinition,
      required this.selectedItemKey,
      required this.onPressed,
      required this.menuButtonHeight,
      required this.getHighlightColor,
      required this.buildMenuItemContent,
      this.iconData})
      : super(key: key);

  final Key? selectedItemKey;
  final IconData? iconData;
  final Function() onPressed;
  final double menuButtonHeight;
  final Color Function() getHighlightColor;
  final Widget Function(MenuItemDefinition menuButtonDefinition,
      bool isSelected, BuildContext context) buildMenuItemContent;
  final MenuItemDefinition menuButtonDefinition;

  bool get isSelected => key == selectedItemKey;

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => Expanded(
            child: SizedBox(
                height: menuButtonHeight,
                child: TextButton(
                  onPressed: onPressed,
                  style: TextButton.styleFrom(
                      backgroundColor: isSelected
                          ? getHighlightColor()
                          : Colors.transparent),
                  child: buildMenuItemContent(
                      menuButtonDefinition, isSelected, context),
                ))),
      );
}

class NavigationDrawerMenu extends StatefulWidget {
  // Whether or not clicking a menu item automatically selects it
  final bool autoSelect;
  final double itemHeight;
  final Color Function() getHighlightColor;
  final EdgeInsetsGeometry itemPadding;
  final Widget Function(MenuItemDefinition menuButtonDefinition,
      bool isSelected, BuildContext context) buildMenuButtonContent;

  // Notifies listeners when the user selects a menu item
  final ValueChanged<Key> onSelectionChanged;
  // The current menu index, and the mechanism for listening to the change of
  // the index externally
  final ValueNotifier<Key?> selectedMenuKey;
  //The list of widgets that appear in the menu
  final ValueNotifier<List<MenuItemContent>> menuItemContentList;
  NavigationDrawerMenu(
      {required this.onSelectionChanged,
      required this.selectedMenuKey,
      required this.menuItemContentList,
      Key? key,
      required this.itemHeight,
      required this.getHighlightColor,
      required this.itemPadding,
      required this.buildMenuButtonContent,
      this.autoSelect = true})
      : super(key: key);

  @override
  NavigationDrawerMenuState createState() => NavigationDrawerMenuState(
      selectedMenuKey, onSelectionChanged, menuItemContentList);
}

//TODO: Hide this type from external assemblies other than test.
class NavigationDrawerMenuState extends State<NavigationDrawerMenu> {
  NavigationDrawerMenuState(
      this._selectedMenuKey, this.onSelectionChanged, this.menuItems) {
    _selectedMenuKey.addListener(_refresh);
    menuItems.addListener(_refresh);
  }

  void _refresh() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  List<Widget> getWidgets() => menuItems.value
      .map((element) => element.widget ?? buildMenuButton(element.menuItem!))
      .toList();

  final ValueNotifier<Key?> _selectedMenuKey;
  final ValueChanged<Key> onSelectionChanged;
  final ValueNotifier<List<MenuItemContent>> menuItems;

  Widget buildMenuButton(MenuItemDefinition menuButtonDefinition) {
    return Padding(
      padding: widget.itemPadding,
      child: _MenuItem(
        menuButtonDefinition: menuButtonDefinition,
      menuButtonHeight: widget.itemHeight,
      getHighlightColor: widget.getHighlightColor,
      key: menuButtonDefinition.key,
      selectedItemKey: _selectedMenuKey.value,
      iconData: menuButtonDefinition.iconData,
      buildMenuItemContent: widget.buildMenuButtonContent,
      onPressed: () {
        if (widget.autoSelect) {
          _selectedMenuKey.value = menuButtonDefinition.key;
        }

        setState(() {
          onSelectionChanged(menuButtonDefinition.key);
        });
        },
      ),
    );
  }

  //TODO: this is a mess. Clean this up
  _MenuItem get selectedMenuButton => (getWidgets().firstWhere((element) =>
          element is Padding &&
          element.child is _MenuItem &&
          element.child!.key == _selectedMenuKey.value) as Padding)
      .child! as _MenuItem;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Column(
        children: getWidgets(),
      ),
    ]);
  }
}
