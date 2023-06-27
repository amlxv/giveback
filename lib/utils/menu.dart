import 'package:flutter/material.dart';
import 'package:giveback/pages/charities.dart';
import 'package:giveback/pages/home.dart';
import 'package:giveback/pages/mylist.dart';
import 'package:giveback/pages/profile.dart';

class MenuItem {
  const MenuItem({required this.iconData, required this.title});
  final IconData iconData;
  final String title;
}

List getScreens(Function? updateIndex) {
  return <Widget>[
    Home(updateIndex: updateIndex),
    const Charities(),
    MyList(updateIndex: updateIndex),
    const Profile(),
  ];
}

const menuItemList = <MenuItem>[
  MenuItem(iconData: Icons.home, title: 'Home'),
  MenuItem(iconData: Icons.list_alt, title: 'Donation'),
  MenuItem(iconData: Icons.download_done, title: 'My List'),
  MenuItem(iconData: Icons.person, title: 'Profile'),
];
