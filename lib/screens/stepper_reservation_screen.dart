
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_queen/widgets/app_drawer.dart';
import 'package:la_queen/widgets/bottom_app_bar.dart';
import 'package:la_queen/widgets/stepper_reservation.dart';

class StepperReservationScreen extends StatefulWidget {
  static const routeName = '/stepper';
  final int i;

  StepperReservationScreen(this.i);

  @override
  _StepperReservationScreenState createState() => _StepperReservationScreenState();
}

class _StepperReservationScreenState extends State<StepperReservationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(
          "Rezervacija termina",
          style: TextStyle(color: Color(0xff2d2d2d)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffFFC592),
        elevation: 20,
      ),
      backgroundColor: Color(0xff2d2d2d),
        body: const Center(
          child: StepperReservation(),
        ),
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
