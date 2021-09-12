import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:la_queen/providers/review.dart';

class Reviews with ChangeNotifier {
  List<Review> _reviews = [];
    
  List<Review> get reviews {
    return [..._reviews];
  }

  double get averageReviws{
    double sum = 0;
    _reviews.forEach((element) {
      sum +=element.star;
    });

    return double.parse((sum/_reviews.length).toStringAsFixed(1));
  }

  final String authToken;
  final String userId;
  final String user;

  Reviews(this.authToken, this._reviews, this.userId, this.user);

  Future<void> getAllReviews() async {
    var _params = <String, String>{
        'auth': authToken
      };

    var url = Uri.https(
        'laqueen-6facf-default-rtdb.europe-west1.firebasedatabase.app',
        '/reviews.json', _params);

    try {
      final response = await http.get(url);
      Map<String, dynamic> extractData = new Map<String, dynamic>.from(json.decode(response.body));
      if (extractData == null) {
        return;
      }

      final List<Review> loadedReviews = [];
      extractData.forEach((reviewId, reviewData) {
        loadedReviews.add(
          Review(
            id: reviewId.toString(),
            user: reviewData['user'],
            date: reviewData['date'],
            star: int.parse(reviewData['star']),
            comment: reviewData['comment']
          ),
        );
      });
      _reviews = loadedReviews;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addReview(Review review) async {
    print("REVIWS USER: " + user);
    
    final url = Uri.https(
        'laqueen-6facf-default-rtdb.europe-west1.firebasedatabase.app',
        '/reviews.json',
        {'auth': '$authToken'});
    try {
      final response = await http.post(url,
          body: json.encode({
            'user': user,
            'date': review.date,
            'star': review.star.toString(),
            'comment': review.comment,
          }));

      final newReview = Review(
            id: json.decode(response.body)['id'],
            user: review.user,
            date: review.date,
            star: review.star,
            comment: review.comment
          );
      _reviews.add(newReview);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

}
