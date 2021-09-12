import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:la_queen/providers/reservation.dart';

class UserReservations with ChangeNotifier {
  List<Reservation> _userReservations = [];

  List<Reservation> get userReservations {
    return [..._userReservations];
  }

  final String authToken;
  final String userId;
  final String user;

  UserReservations(this.authToken, this._userReservations, this.userId, this.user);

  Future<void> fetchReservationByUser() async {
    var _params;
    _params = <String, String>{
      'auth': authToken,
      'orderBy': json.encode("creatorId"),
      'equalTo': json.encode(userId),
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
      _userReservations = loadedReservations;

      _userReservations.sort((first, second) => 
                DateFormat('dd.MM.yyyy').parse(second.date).compareTo(DateFormat('dd.MM.yyyy').parse(first.date)));

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> setStatusReservation(String id, String status) async {
    var reservationItem =
        _userReservations.indexWhere((element) => element.id == id);
    if (reservationItem >= 0) {
      final url = Uri.https(
          'laqueen-6facf-default-rtdb.europe-west1.firebasedatabase.app',
          '/reservations/$id.json',
          {'auth': '$authToken'});
      await http.patch(url, body: json.encode({'status': status}));
      _userReservations[reservationItem].status = status;
      notifyListeners();
    }
  }
}
