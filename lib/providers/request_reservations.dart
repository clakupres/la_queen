import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:la_queen/providers/reservation.dart';

class RequestReservations with ChangeNotifier {
  List<Reservation> _requestReservations = [];

  List<Reservation> get requestReservations {
    return [..._requestReservations];
  }

  final String authToken;
  final String userId;
  final String user;

  RequestReservations(this.authToken, this._requestReservations, this.userId, this.user);

  Future<void> getAllInProcessReservation() async {
    var _params = <String, String>{
      'auth': authToken,
      'orderBy': json.encode("status"),
      'equalTo': json.encode("u tijeku"),
    };

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
      _requestReservations = loadedReservations;

      _requestReservations.sort((first, second) => 
                DateFormat('dd.MM.yyyy').parse(first.date).compareTo(DateFormat('dd.MM.yyyy').parse(second.date)));
                
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> setStatusReservation(String id, String status) async {
    var reservationItem =
        _requestReservations.indexWhere((element) => element.id == id);
    if (reservationItem >= 0) {
      final url = Uri.https(
          'laqueen-6facf-default-rtdb.europe-west1.firebasedatabase.app',
          '/reservations/$id.json',
          {'auth': '$authToken'});
      await http.patch(url, body: json.encode({'status': status}));
      _requestReservations[reservationItem].status = status;
      notifyListeners();
    }
  }
}
