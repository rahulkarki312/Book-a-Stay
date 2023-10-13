import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'userReview.dart';
import 'package:http/http.dart' as http;

// import '../providers/hotels.dart';

class Hotel with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final num price;
  final String imageUrl;
  bool isFavorite;
  final num discount;
  final String address;
  final bool breakfastIncl;
  final List<ReviewDetails> reviews;

  Hotel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
    required this.discount,
    required this.address,
    required this.breakfastIncl,
    required this.reviews,
  });

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    isFavorite = !isFavorite;
    final url = Uri.parse(
        'https://book-a-stay-app-default-rtdb.firebaseio.com/userfavorites/$userId/$id.json?auth=$authToken');
    var response = await http.put(url,
        body: json.encode(
          isFavorite,
        ));
    notifyListeners();
  }

  int get reviewsCount {
    return reviews.length;
  }

  double get avgRating {
    double sum = 0;
    reviews.forEach((review) {
      sum += review.rating;
    });
    return sum / reviewsCount;
  }
}
