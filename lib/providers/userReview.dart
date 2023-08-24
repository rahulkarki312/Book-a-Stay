import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReviewDetails with ChangeNotifier {
  String id;
  String userId;
  String review;
  int rating;
  DateTime date;
  ReviewDetails(
      {required this.id,
      required this.userId,
      required this.review,
      required this.rating,
      required this.date});

  String get getReview {
    return review;
  }
}

// class UserReview with ChangeNotifier {
//   final String userId;
//   final String authToken;
//   List<reviewDetails> _reviews = [];
//   UserReview(this.userId, this.authToken, this._reviews);

//   List<reviewDetails> get reviews {
//     return _reviews;
//   }

//   Future<void> addReview(String review, int rating, String hotelId) async {
   
//   }
// }
