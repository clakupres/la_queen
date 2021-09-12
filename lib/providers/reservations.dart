import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:la_queen/providers/chart_reservation.dart';
import 'dart:convert';

import 'package:la_queen/providers/reservation.dart';

class Reservations with ChangeNotifier {
  List<Reservation> _reservations = [];

  List<Reservation> get reservations {
    return [..._reservations];
  }

  final String authToken;
  final String userId;
  final String user;

  Reservations(this.authToken, this._reservations, this.userId, this.user);

  Reservation findById(String id) {
    return _reservations.firstWhere((reservation) => reservation.id == id);
  }

  List<Reservation> findAllByDate(String date) {
    return _reservations
        .where((reservation) =>
            reservation.date == date &&
            (reservation.status == "odobreno" ||
                reservation.status == "u tijeku"))
        .toList();
  }

  List<ChartReservation> getChartData(){
    List<ChartReservation> chartList = [];
    int odobreno = 0;
    int otkazano = 0;
    int tijeku = 0;
    
    for (Reservation reservation in _reservations) {
      if(reservation.status=="odobreno"){
        odobreno++;
      }else if(reservation.status=="otkazano"){
        otkazano++;
      }else{
        tijeku++;
      }
    }

    chartList.add(new ChartReservation("Odobreno", odobreno, Colors.green));
    chartList.add(new ChartReservation("Otkazano", otkazano, Colors.red));
    chartList.add(new ChartReservation("U tijeku", tijeku, Colors.orange));
    
    return chartList;
  }

  Set<String> findAllBookedTimeByDate(List<Reservation> bookedReservations) {
    LinkedHashSet<String> allBookedTimes = new LinkedHashSet();
    bookedReservations.forEach((element) {
      if (element.duration == 1) {
        allBookedTimes.add(element.time);
      } else if (element.duration == 2) {
        allBookedTimes.add(element.time);
        allBookedTimes.add((int.parse(element.time) + 1).toString());
      }
    });
    return allBookedTimes;
  }

  Future<void> fetchAndSetReservation([bool filterByUser = false]) async {
    var _params;
    if (filterByUser) {
      _params = <String, String>{
        'auth': authToken,
        'orderBy': json.encode("creatorId"),
        'equalTo': json.encode(userId),
      };
    }
    if (filterByUser == false) {
      _params = <String, String>{'auth': authToken};
    }

    var url = Uri.https(
        'laqueen-6facf-default-rtdb.europe-west1.firebasedatabase.app',
        '/reservations.json',
        _params);

    try {
      final response = await http.get(url);
      Map<String, dynamic> extractData =
          new Map<String, dynamic>.from(json.decode(response.body));
      if (extractData == null) {
        return;
      }

      final List<Reservation> loadedReservations = [];
      extractData.forEach((reseId, reservationData) {
        loadedReservations.add(
          Reservation(
              id: reseId.toString(),
              service: reservationData['service'],
              nailSize: reservationData['nailSize'],
              date: reservationData['date'],
              time: reservationData['time'],
              duration: reservationData['duration'],
              status: reservationData['status'],
              user: reservationData["user"]),
        );
      });
      _reservations = loadedReservations;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addReservation(Reservation reservation) async {

    final url = Uri.https(
        'laqueen-6facf-default-rtdb.europe-west1.firebasedatabase.app',
        '/reservations.json',
        {'auth': '$authToken'});
    try {
      final response = await http.post(url,
          body: json.encode({
            'service': reservation.service,
            'nailSize': reservation.nailSize,
            'date': reservation.date,
            'time': reservation.time,
            'creatorId': userId,
            'duration': reservation.duration,
            'user': user,
            'status': "u tijeku"
          }));
      final newReservation = Reservation(
          id: json.decode(response.body)['id'],
          service: reservation.service,
          nailSize: reservation.nailSize,
          date: reservation.date,
          time: reservation.time,
          duration: reservation.duration,
          user: reservation.user,
          status: "u tijeku");
      _reservations.add(newReservation);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
