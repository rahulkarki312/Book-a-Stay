import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/userfilter.dart';

import './hotel.dart';
// import '../models/http_exceptions.dart';

class Hotels with ChangeNotifier {
  List<Hotel> _hotels = [];

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
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // if (extractedData == null) {
      //   return;
      // }

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
      final newHotel = Hotel(
          title: hotel.title,
          description: hotel.description,
          price: hotel.price,
          imageUrl: hotel.imageUrl,
          id: json.decode(response.body)['name'],
          breakfastIncl: hotel.breakfastIncl,
          discount: hotel.discount,
          address: hotel.address);
      _hotels.add(newHotel);
      // _items.insert(0, newhotel); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future updateHotel(String id, Hotel newHotel) async {
    final hotelIndex = _hotels.indexWhere((hotel) => hotel.id == id);

    if (hotelIndex >= 0) {
      final url = Uri.parse(
          "https://book-a-stay-app-default-rtdb.firebaseio.com/hotels/$id.json?auth=$authToken");

      await http.patch(url,
          body: json.encode({
            'title': newHotel.title,
            'description': newHotel.description,
            'imageUrl': newHotel.imageUrl,
            'price': newHotel.price,
            'breakfastIncl': newHotel.breakfastIncl,
            'discount': newHotel.discount,
            'address': newHotel.address
          }));
      _hotels[hotelIndex] = newHotel;
      notifyListeners();
    } else {
      print('...');
    }
  }
}
