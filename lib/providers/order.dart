import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/userfilter.dart';

class Order with ChangeNotifier {
  final String id;
  final String userId;
  final String hotelId;
  final DateTime checkInDay;
  final DateTime checkOutDay;
  final int customerCount;
  final num price;

  Order(
      {required this.id,
      required this.hotelId,
      required this.userId,
      required this.checkInDay,
      required this.checkOutDay,
      required this.customerCount,
      required this.price});
}
