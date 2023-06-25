import 'package:flutter/material.dart';
import 'package:giveback/utils/menu.dart';

class NavBar extends StatefulWidget {
  final int index;
  final Function updateIndex;

  const NavBar({super.key, required this.index, required this.updateIndex});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.index,
      onTap: (int index) => widget.updateIndex(index),
      elevation: 16.0,
      items: menuItemList
          .map((m) =>
              BottomNavigationBarItem(icon: Icon(m.iconData), label: m.title))
          .toList(),
    );
  }
}
