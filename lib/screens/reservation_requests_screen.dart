import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_queen/providers/request_reservations.dart';
import 'package:la_queen/widgets/app_drawer.dart';
import 'package:la_queen/widgets/bottom_app_bar.dart';
import 'package:la_queen/widgets/requests_reservation.dart';
import 'package:provider/provider.dart';

class ReservationRequestaScreen extends StatefulWidget {
  static const routeName = '/reservations-calendar';
  final int i;

  ReservationRequestaScreen(this.i);

  @override
  _ReservationRequestaScreenState createState() =>
      _ReservationRequestaScreenState();
}

class _ReservationRequestaScreenState
    extends State<ReservationRequestaScreen> {
  
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

      Provider.of<RequestReservations>(context).getAllInProcessReservation().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Zahtjevi za rezervacije",
          style: TextStyle(color: Color(0xff2d2d2d)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffFFC592),
        elevation: 20,
      ),
      backgroundColor: Color(0xff2d2d2d),
      body: _isLoading
          ? Center(
          child: 
            Platform.isIOS ? 
            CupertinoTheme(data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark), child: CupertinoActivityIndicator())
            :CircularProgressIndicator())
          : RequestReservation(),
      bottomNavigationBar: BottomNavigationAppBar(3),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xff2d2d2d),
        ),
        child: AppDrawer(),
      ),
    );
  }
}