import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_queen/providers/request_reservations.dart';
import 'package:la_queen/screens/reservation_requests_screen.dart';
import 'package:provider/provider.dart';

class RequestReservation extends StatefulWidget {

  @override
  _RequestReservationState createState() => _RequestReservationState();
}

class _RequestReservationState extends State<RequestReservation> {

  Future<void> _updateStatus(String id, String status) async {
    await Provider.of<RequestReservations>(context, listen: false)
        .setStatusReservation(id, status)
        .then((value) => Navigator.of(context).push(
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => ReservationRequestaScreen(2)),
            ));
  }
  
  @override
  Widget build(BuildContext context) {
    final reservationData = Provider.of<RequestReservations>(context);
        
    return reservationData.requestReservations.length >0 ? SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                  child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                primary: false,
                itemCount: reservationData.requestReservations.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8.0, left: 15, right: 15),
                    child: Card(
                      color: Color(0xff404040),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                        " Datum: " +
                                            reservationData
                                                .requestReservations[index].date,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xffFFC592))),
                                  ),
                                  if (reservationData
                                          .requestReservations[index].status ==
                                      "u tijeku")
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(fontSize: 11),
                                            primary: Color(0xffFFC592)),
                                        onPressed: () {
                                          _updateStatus(
                                              reservationData
                                                  .requestReservations[index].id,
                                              "odobreno");
                                        },
                                        child: Text('PRIHVATI'),
                                      ),
                                    ),
                                  if (reservationData
                                          .requestReservations[index].status !=
                                      "otkazano")
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 5.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(fontSize: 11),
                                            primary: Colors.grey),
                                        onPressed: () {
                                          _updateStatus(
                                              reservationData
                                                  .requestReservations[index].id,
                                              "otkazano");
                                        },
                                        child: Text('OTKAŽI'),
                                      ),
                                    )
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Platform.isIOS ? 
                                    Icon(CupertinoIcons.person, color: Color(0xffFFC592))
                                     : 
                                  Icon(Icons.person,
                                      color: Color(0xffFFC592)),
                                  Text(" Korisnik: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffFFC592))),
                                  Text(
                                      reservationData.requestReservations[index].user,
                                      style: TextStyle(color: Color(0xffFFC592)))
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                    Platform.isIOS ? 
                                    Icon(CupertinoIcons.clock, color: Color(0xffFFC592))
                                    :
                                    Icon(Icons.schedule,
                                        color: Color(0xffFFC592)),
                                    Text(" Vrijeme: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffFFC592))),
                                    Text(
                                        reservationData
                                                .requestReservations[index].time +
                                            ":00 h",
                                        style: TextStyle(
                                            color: Color(0xffFFC592))),
                                  ]),
                                  Row(
                                    children: [
                                      Platform.isIOS ? 
                                    Icon(CupertinoIcons.timer, color: Color(0xffFFC592))
                                     : 
                                      Icon(Icons.timelapse,
                                          color: Color(0xffFFC592)),
                                      Text(" Trajanje: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xffFFC592))),
                                      Text(
                                          reservationData
                                                  .requestReservations[index].duration
                                                  .toString() +
                                              " h",
                                          style: TextStyle(
                                              color: Color(0xffFFC592)))
                                    ],
                                  )
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Platform.isIOS ? 
                                    Icon(CupertinoIcons.bag, color: Color(0xffFFC592))
                                    : 
                                    Icon(Icons.design_services,
                                        color: Color(0xffFFC592)),
                                    Text(" Usluga: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffFFC592))),
                                    Text(
                                        reservationData
                                            .requestReservations[index].service,
                                        style: TextStyle(
                                            color: Color(0xffFFC592))),
                                  ]),
                                  Row(
                                    children: [
                                      Platform.isIOS ? 
                                    Icon(CupertinoIcons.textformat_size, color: Color(0xffFFC592))
                                    : 
                                      Icon(Icons.straighten,
                                          color: Color(0xffFFC592)),
                                      Text(" Veličina: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xffFFC592))),
                                      Text(
                                          reservationData
                                              .requestReservations[index].nailSize,
                                          style: TextStyle(
                                              color: Color(0xffFFC592)))
                                    ],
                                  )
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Platform.isIOS ? 
                                      Icon(CupertinoIcons.hourglass_bottomhalf_fill, color: Color(0xffFFC592)):
                                      Icon(Icons.hourglass_bottom, color: Color(0xffFFC592)),
                                  Text(" Status: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffFFC592))),
                                  Text(
                                      reservationData
                                          .requestReservations[index].status,
                                      style:
                                          TextStyle(color: Color(0xffFFC592)))
                                ]),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3),
              )))
              : Container();
  }
}