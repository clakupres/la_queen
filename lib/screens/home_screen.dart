
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:la_queen/widgets/app_drawer.dart';
import 'package:la_queen/widgets/bottom_app_bar.dart';
import 'package:la_queen/widgets/home_tab_menu.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-page';
  final int i;

  HomeScreen(this.i);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "LaQueen",
            style: TextStyle(color: Color(0xff2d2d2d)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffFFC592),
          elevation: 20,
        ),
        backgroundColor: Color(0xff2d2d2d),
        body: TabBarView(
          children: <Widget>[
            HomeTabMenu(),
          ],
          controller: _tabController,
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color(0xff2d2d2d),
          ),
          child: AppDrawer(),
        ),
        bottomNavigationBar: BottomNavigationAppBar(widget.i));
  }
}
