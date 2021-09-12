import 'package:flutter/foundation.dart';

class Reservation {
  final String id;
  final String service;
  final String nailSize;
  final String date;
  final String time;
  final int duration;
  String status;
  final String user;

  Reservation(
      {@required this.id,
      @required this.service,
      @required this.nailSize,
      @required this.date,
      @required this.time,
      @required this.duration,
      @required this.status,
      @required this.user
      });

}
