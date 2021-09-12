import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:la_queen/providers/review.dart';
import 'package:la_queen/providers/reviews.dart';
import 'package:la_queen/providers/user_reservations.dart';
import 'package:la_queen/screens/user_calendar_screen.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';

class UserRequestsReservation extends StatefulWidget {

  @override
  _UserRequestsReservationState createState() => _UserRequestsReservationState();
}

class _UserRequestsReservationState extends State<UserRequestsReservation> {

  Future<void> _updateStatus(String id, String status) async{
    Provider.of<UserReservations>(context, listen: false)
        .setStatusReservation(id, status)
        .then((value) => Navigator.of(context).push(
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => UserCalendarScreen(3)),
            ));
  }
  
  @override
  Widget build(BuildContext context) {
    final reservationData = Provider.of<UserReservations>(context, listen: false);
    final reviewData = Provider.of<Reviews>(context);

    void _showRatingAppDialog() {
      final _ratingDialog = RatingDialog(
        ratingColor: Color(0xffFFC592),
        title: 'Ostavite recenziju salonu',
        image: Image.asset(
          "assets/images/logo.png",
          height: 140,
        ),
        submitButton: 'Ocjenite',
        onCancelled: () => print('cancelled'),
        onSubmitted: (response) {
          Review review = new Review(
              id: '',
              user: reviewData.user,
              date: "${DateFormat('dd.MM.yyyy').format(DateTime.now())}",
              star: response.rating,
              comment: response.comment);
          reviewData.addReview(review);
          Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => UserCalendarScreen(3)),
          );
        },
      );

      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return Theme(
                data: Theme.of(context)
                    .copyWith(dialogBackgroundColor: Colors.grey[700]),
                child: _ratingDialog);
          });
    }
    
    return reservationData.userReservations.length > 0 ? SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                  child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                primary: false,
                itemCount: reservationData.userReservations.length == null
                    ? 0
                    : reservationData.userReservations.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 2.0, left: 15, right: 15),
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
                                                .userReservations[index].date,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xffFFC592))),
                                  ),
                                  if (reservationData
                                          .userReservations[index].status !=
                                      "otkazano" && (DateTime.now().day != DateFormat('dd.MM.yyyy').parse(reservationData.userReservations[index].date).day)
                                       && DateTime.now().isBefore(
                                        DateFormat('dd.MM.yyyy').parse(reservationData.userReservations[index].date)) 
                                      )
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
                                                  .userReservations[index].id,
                                              "otkazano");
                                        },
                                        child: Text('OTKAŽI'),
                                      ),
                                    ),
                                if (reservationData
                                          .userReservations[index].status ==
                                      "odobreno" && DateTime.now().millisecondsSinceEpoch >
                                        DateFormat('dd.MM.yyyy HH:mm').parse(reservationData.userReservations[index].date + ' ' + 
                                        (int.parse(reservationData.userReservations[index].time) + 
                                        reservationData.userReservations[index].duration).toString() + ':00').millisecondsSinceEpoch 
                                      )
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          textStyle: TextStyle(fontSize: 11),
                                          primary: Color(0xffFFC592)),
                                      onPressed: _showRatingAppDialog,
                                      child: Text('OCJENI'),
                                    ),
                                  )
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
                                    : Icon(Icons.schedule,
                                        color: Color(0xffFFC592)),
                                    Text(" Vrijeme: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffFFC592))),
                                    Text(
                                        reservationData
                                                .userReservations[index].time +
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
                                                  .userReservations[index].duration
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
                                            .userReservations[index].service,
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
                                              .userReservations[index].nailSize,
                                          style: TextStyle(
                                              color: Color(0xffFFC592)))
                                    ],
                                  )
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  reservationData.userReservations[index].status == "odobreno" ? 
                                    Platform.isIOS ? 
                                      Icon(CupertinoIcons.check_mark_circled, color: Color(0xffFFC592)):
                                      Icon(Icons.task_alt, color: Color(0xffFFC592)) 
                                    : reservationData.userReservations[index].status == "u tijeku" ?
                                    Platform.isIOS ? 
                                      Icon(CupertinoIcons.hourglass_bottomhalf_fill, color: Color(0xffFFC592)):
                                      Icon(Icons.hourglass_bottom, color: Color(0xffFFC592)) :
                                    Platform.isIOS ? 
                                      Icon(CupertinoIcons.xmark_circle, color: Color(0xffFFC592)):
                                      Icon(Icons.cancel, color: Color(0xffFFC592)),
                                  Text(" Status: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffFFC592))),
                                  Text(
                                      reservationData
                                          .userReservations[index].status,
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
                    childAspectRatio: 2.2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3),
              )))
              : Container();
  }
}