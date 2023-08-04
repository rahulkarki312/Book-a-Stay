// import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

class UserFilter with ChangeNotifier {
  // DateTime _today = DateTime.now();
  DateTime _checkInDay = DateTime.now();
  DateTime _checkOutDay = DateTime.now().add(Duration(days: 1));
  String? _location;

  void setFilter(DateTime checkInDay, DateTime checkOutDay, String location) {
    _checkInDay = checkInDay;
    _checkOutDay = checkOutDay;
    _location = location;
    notifyListeners();
  }

  String? get location {
    return _location;
  }

  int get noOfDays {
    return _checkOutDay.difference(_checkInDay).inDays;
  }
}
