import 'package:flutter/foundation.dart';

class Review {
  final String id;
  final String user;
  final String date;
  final int star;
  final String comment;

  Review(
      {@required this.id,
      @required this.user,
      @required this.date,
      @required this.star,
      this.comment
      });

}
