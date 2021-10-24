# navigation_drawer_menu

## Flutter Material Design Navigation Drawer Menu

[Navigation drawer](https://material.io/components/navigation-drawer) is a common UI pattern for adaptive menus. The [Material Design](https://material.io/) documentation formalizes the behavior of the menu but this pattern is not peculiar to Material Design. The pattern includes a basic Hamburger menu but isn't limited to small screens. The menu pattern suits all screen sizes. On larger width screens you see the icon and text, smaller screens will display icons only, and on phones, the menu will disappear during normal use and slide in with the hamburger icon.

![Hamburger Menu](https://github.com/MelbourneDeveloper/navigation_drawer_menu/blob/main/Documentation/Images/Hamburger.gif) 

## Example

The example aims to implement the Navigation Drawer pattern documented above. This is a work in progress and conformance to the behavior in the Material Design documentation is the long term aim. Pull requests to fix behavior are welcome. The example works on all form factors: desktop and tablet (landscape, portrait), phone, and web. Try resizing the width of the window to see how the behavior changes.

![Hamburger Menu](https://github.com/MelbourneDeveloper/navigation_drawer_menu/blob/main/Documentation/Images/Hamburger2.gif) 

![Hamburger Menu](https://github.com/MelbourneDeveloper/navigation_drawer_menu/blob/main/Documentation/Images/chrome.png) 

### Run the Example

- Open the root folder in Visual Studio Code
- Open a terminal window
- Add platforms by running these commands in the root folder (not example folder)
- Click Run -> Start Debugging

```
flutter create example --platforms=windows,macos,linux

flutter create --platforms=web

flutter create --platforms=android
```

## [`NavigationDrawerMenu`](https://github.com/MelbourneDeveloper/navigation_drawer_menu/blob/443b99c23abf6c192419ba87f1f9b0e0139c6ca9/lib/navigation_drawer_menu.dart#L66)

This is a widget that basically functions like a [`ListView`](https://api.flutter.dev/flutter/widgets/ListView-class.html). However, it exists to remove some of the boilerplate code necessary for constructing the menu, and allows you to put arbitrary sized spacers and headings inside the menu. The example uses this set of definitions. If you don't want to use this widget, you can use `ListView` instead.

```Dart
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
```
