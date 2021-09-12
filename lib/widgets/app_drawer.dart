import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_queen/providers/auth.dart';
import 'package:la_queen/screens/chart_screen.dart';
import 'package:la_queen/screens/reservation_requests_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Izbornik'),
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xffFFC592),
          ),
          Divider(),
          Provider.of<Auth>(context).user == "hhqNqArP31MQMH8BK4NK0K8CZSn1"
              ? ListTile(
                  leading: 
                    Platform.isIOS ?
                    Icon(CupertinoIcons.calendar_today,color: Colors.grey)
                    : Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                  ),
                  title: Text('Zahtjevi za rezervacije',
                      style: TextStyle(color: Colors.grey)),
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              ReservationRequestaScreen(2)),
                    );
                  },
                )
              : Container(),
          Provider.of<Auth>(context).user == "hhqNqArP31MQMH8BK4NK0K8CZSn1"
              ? Divider()
              : Container(),
          Provider.of<Auth>(context).user == "hhqNqArP31MQMH8BK4NK0K8CZSn1"
              ? ListTile(
                  leading: 
                  Platform.isIOS ?
                    Icon(CupertinoIcons.chart_pie,color: Colors.grey)
                    : 
                  Icon(
                    Icons.add_chart,
                    color: Colors.grey,
                  ),
                  title:
                      Text('Statistika', style: TextStyle(color: Colors.grey)),
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => ChartReserationsScreen()));
                  },
                )
              : Container(),
          Provider.of<Auth>(context).user == "hhqNqArP31MQMH8BK4NK0K8CZSn1"
              ? Divider()
              : Container(),
          ListTile(
            leading: 
            Platform.isIOS ?
                    Icon(CupertinoIcons.arrow_left,color: Colors.grey)
                    : Icon(Icons.exit_to_app, color: Colors.grey),
            title: Text('Odjava', style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
