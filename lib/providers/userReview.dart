import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReviewDetails with ChangeNotifier {
  String id;
  String userId;
  String username;
  String review;
  double rating;
  DateTime date;
  ReviewDetails(
      {required this.id,
      required this.userId,
      required this.username,
      required this.review,
      required this.rating,
      required this.date});

  String get getReview {
    return review;
  }
}
