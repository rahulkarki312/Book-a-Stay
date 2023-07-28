import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './hotel.dart';
import '../models/http_exceptions.dart';

import 'dart:convert';

class Hotels with ChangeNotifier {
  List<Hotel> _hotels = [];

  final String authToken;
  final String userId;

  Hotels(this.authToken, this.userId, this._hotels);

  List<Hotel> get hotels {
    return [..._hotels];
  }

  List<Hotel> get favoriteHotels {
    return _hotels.where((hotel) => hotel.isFavorite).toList();
  }

  Hotel findById(String id) {
    return _hotels.firstWhere((prod) => prod.id == id);
  }

  Future addHotel(Hotel hotel) {
    throw ('x');
  }

  Future updateHotel(String id, Hotel hotel) {
    throw ('x');
  }
}
