import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_queen/providers/reviews.dart';
import 'package:la_queen/providers/user_reservations.dart';
import 'package:la_queen/widgets/app_drawer.dart';
import 'package:la_queen/widgets/bottom_app_bar.dart';
import 'package:la_queen/widgets/user_requests_reservation.dart';
import 'package:provider/provider.dart';

class UserCalendarScreen extends StatefulWidget {
  static const routeName = '/user-calendar';
  final int i;

  UserCalendarScreen(this.i);

  @override
  _UserCalendarScreenState createState() => _UserCalendarScreenState();
}

class _UserCalendarScreenState extends State<UserCalendarScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Reviews>(context).getAllReviews();
      Provider.of<UserReservations>(context).fetchReservationByUser().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Moje rezervacije",
          style: TextStyle(color: Color(0xff2d2d2d)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffFFC592),
        elevation: 20,
      ),
      backgroundColor: Color(0xff2d2d2d),
      body: _isLoading
          ? Center(
              child: Platform.isIOS
                  ? CupertinoTheme(
                      data: CupertinoTheme.of(context)
                          .copyWith(brightness: Brightness.dark),
                      child: CupertinoActivityIndicator())
                  : CircularProgressIndicator())
          : UserRequestsReservation(),
      bottomNavigationBar: BottomNavigationAppBar(widget.i),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xff2d2d2d),
        ),
        child: AppDrawer(),
      ),
    );
  }
}
