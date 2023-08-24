import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/userfilter.dart';
import 'userReview.dart';
import '../models/http_exceptions.dart';
import './hotel.dart';
// import '../models/http_exceptions.dart';

class Hotels with ChangeNotifier {
  List<Hotel> _hotels = [];
  List<ReviewDetails> _reviews = [];

  final String authToken;
  final String userId;

  Hotels(this.authToken, this.userId, this._hotels);

  List<Hotel> get hotels {
    return [..._hotels];
  }

  List<String> get locations {
    List<String> locations = [];
    for (Hotel hotel in _hotels) {
      String location = hotel.address;
      if (!locations.contains(location)) {
        locations.add(location);
      }
    }
    return locations;
  }

  List<Hotel> get favoriteHotels {
    return _hotels.where((hotel) => hotel.isFavorite).toList();
  }

  Hotel findById(String? id) {
    return _hotels.firstWhere((hotel) => hotel.id == id);
  }

  Future fetchAndSetHotels() async {
    final url = Uri.parse(
        "https://book-a-stay-app-default-rtdb.firebaseio.com/hotels.json?auth=$authToken");
    final favoriteDataUrl = Uri.parse(
        'https://book-a-stay-app-default-rtdb.firebaseio.com/userfavorites/$userId.json?auth=$authToken');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final favoriteResponse = await http.get(favoriteDataUrl);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Hotel> LoadedHotels = [];
      extractedData.forEach((hotelId, hotelData) {
        LoadedHotels.add(Hotel(
          id: hotelId,
          title: hotelData['title'],
          description: hotelData['description'],
          price: hotelData['price'],
          imageUrl: hotelData['imageUrl'],
          breakfastIncl: hotelData['breakfastIncl'] == null
              ? false
              : hotelData['breakfastIncl'],
          discount:
              hotelData['discount'] == null ? 0.0 : (hotelData['discount']),
          address: hotelData['address'],
          isFavorite:
              favoriteData == null ? false : favoriteData[hotelId] ?? false,
          reviews: [],
        ));
      });
      _hotels = LoadedHotels;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future addHotel(Hotel hotel) async {
    final url = Uri.parse(
        "https://book-a-stay-app-default-rtdb.firebaseio.com/hotels.json?auth=$authToken");
    try {
      // adding to server
      final response = await http.post(
        url,
        body: json.encode({
          'title': hotel.title,
          'description': hotel.description,
          'imageUrl': hotel.imageUrl,
          'price': hotel.price,
          'creatorId': userId,
          'breakfastIncl': hotel.breakfastIncl,
          'discount': hotel.discount,
          'address': hotel.address
        }),
      );
      // adding  locally
      final selectedHotel = Hotel(
          title: hotel.title,
          description: hotel.description,
          price: hotel.price,
          imageUrl: hotel.imageUrl,
          id: json.decode(response.body)['name'],
          breakfastIncl: hotel.breakfastIncl,
          discount: hotel.discount,
          address: hotel.address,
          reviews: []);
      _hotels.add(selectedHotel);
      // _items.insert(0, selectedHotel); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future updateHotel(String id, Hotel selectedHotel) async {
    final hotelIndex = _hotels.indexWhere((hotel) => hotel.id == id);

    if (hotelIndex >= 0) {
      final url = Uri.parse(
          "https://book-a-stay-app-default-rtdb.firebaseio.com/hotels/$id.json?auth=$authToken");

      await http.patch(url,
          body: json.encode({
            'title': selectedHotel.title,
            'description': selectedHotel.description,
            'imageUrl': selectedHotel.imageUrl,
            'price': selectedHotel.price,
            'breakfastIncl': selectedHotel.breakfastIncl,
            'discount': selectedHotel.discount,
            'address': selectedHotel.address
          }));
      _hotels[hotelIndex] = selectedHotel;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> addReview(String review, int rating, String hotelId) async {
    final hotelIndex = _hotels.indexWhere((hotel) => hotel.id == hotelId);
    final selectedHotel = _hotels[hotelIndex];
    try {
      if (hotelIndex >= 0) {
        final postUrl = Uri.parse(
            "https://book-a-stay-app-default-rtdb.firebaseio.com/hotels/$hotelId/reviews.json?auth=$authToken");

        final response = await http.post(postUrl,
            body: json.encode({
              'userId': userId,
              'review': review,
              'rating': rating,
              'date': DateTime.now().toString()
            }));
        _reviews.add(ReviewDetails(
            id: json.decode(response.body)['name'],
            userId: userId,
            review: review,
            rating: rating,
            date: DateTime.now()));
        notifyListeners();
      } else {
        print('...');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetReviews(String hotelId) async {
    final url = Uri.parse(
        "https://book-a-stay-app-default-rtdb.firebaseio.com/hotels/$hotelId/reviews.json?auth=$authToken");
    List<ReviewDetails> loadedReviews = [];
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // print(extractedData);
      extractedData.forEach((reviewId, review) {
        loadedReviews.add(ReviewDetails(
            id: reviewId,
            userId: review['userId'],
            review: review['review'],
            rating: int.parse(review['rating'].toString()),
            date: DateTime.parse(review['date'])));
      });
      _reviews = loadedReviews;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future removeReview(String reviewId, String hotelId) async {
    final url = Uri.parse(
        'https://book-a-stay-app-default-rtdb.firebaseio.com/hotels/$hotelId/reviews/$reviewId.json?auth=$authToken');
    final existingReviewIndex =
        _reviews.indexWhere((review) => review.id == reviewId);
    var existingreview = _reviews[existingReviewIndex];
    _reviews.removeAt(existingReviewIndex);
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _reviews.insert(existingReviewIndex, existingreview);
      notifyListeners();
      throw HttpException("Could not delete review");
    }
  }

  List<ReviewDetails> get reviews {
    return _reviews;
  }
}
