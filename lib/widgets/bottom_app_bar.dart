import 'dart:io';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_queen/screens/home_screen.dart';
import 'package:la_queen/screens/reviews_screen.dart';
import 'package:la_queen/screens/stepper_reservation_screen.dart';
import 'package:la_queen/screens/user_calendar_screen.dart';

const _pages = <String, IconData>{
  'pocetna': Icons.home,
  'recenzije': Icons.reviews,
  'rezervacija': Icons.add,
  'kalendar': Icons.calendar_today,
};

const _pagesCupertino = <String, Icon>{
  'pocetna': Icon(CupertinoIcons.home, size: 28),
  'recenzije': Icon(CupertinoIcons.star, size: 28),
  'rezervacija': Icon(CupertinoIcons.add, size: 28),
  'kalendar': Icon(CupertinoIcons.calendar, size: 28),
};

class BottomNavigationAppBar extends StatefulWidget {
  static int bottomIndex;

  BottomNavigationAppBar(bottomIndex);

  @override
  _BottomNavigationAppBarState createState() => _BottomNavigationAppBarState();
}

class _BottomNavigationAppBarState extends State<BottomNavigationAppBar> {
  TabStyle _tabStyle = TabStyle.reactCircle;

  @override
  Widget build(BuildContext context) {
    return new ConvexAppBar.badge(
      const <int, dynamic>{0: ''},
      backgroundColor: Color(0xff404040),
      color: Color(0xffFFC491),
      activeColor: Color(0xffFFC491),
      style: _tabStyle,
      initialActiveIndex: BottomNavigationAppBar.bottomIndex,
      items: <TabItem>[
        for (final menu in Platform.isIOS ? _pagesCupertino.entries : _pages.entries)
          TabItem(icon: menu.value),
      ],
      onTap: (int i) => {
        setState(() {
          BottomNavigationAppBar.bottomIndex = i;
        }),
        
        if (i == 0)
          {
            Navigator.of(context).push(
              PageRouteBuilder(pageBuilder: (_, __, ___) => HomeScreen(0)),
            )
          }
          else if (i == 1)
          {
            Navigator.of(context).push(
              PageRouteBuilder(pageBuilder: (_, __, ___) => ReviewsScreen(1)))
          }
        else if (i == 2)
          {
            Navigator.of(context).push(
              PageRouteBuilder(pageBuilder: (_, __, ___) => StepperReservationScreen(2)),
            )
          }
        else if (i == 3)
          {
            Navigator.of(context).push(
              PageRouteBuilder(pageBuilder: (_, __, ___) => UserCalendarScreen(3)),
            )
          }
      },
    );
  }
}
