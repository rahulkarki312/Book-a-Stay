import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/userfilter.dart';
import 'order.dart';
import '../models/http_exceptions.dart';

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;
  List<Order> _orders = [];
  final bool isAdmin;
  Orders(this.authToken, this.userId, this._orders, this.isAdmin);

  List<Order> get orders {
    return _orders;
  }

  Future addOrder(Order order) async {
    final url = Uri.parse(
        "https://book-a-stay-app-default-rtdb.firebaseio.com/orders.json?auth=$authToken");
    try {
      // adding to server
      final response = await http.post(
        url,
        body: json.encode({
          'userId': order.userId,
          'hotelId': order.hotelId,
          'checkInDay': order.checkInDay.toString(),
          'checkOutDay': order.checkOutDay.toString(),
          'customerCount': order.customerCount,
          'price': order.price
        }),
      );
      // adding  locally
      final newOrder = Order(
          id: json.decode(response.body)['name'],
          hotelId: order.hotelId,
          userId: order.userId,
          checkInDay: order.checkInDay,
          checkOutDay: order.checkOutDay,
          customerCount: order.customerCount,
          price: order.price);
      _orders.insert(0, newOrder);
      // _orders.insert(0, newhotel); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future fetchAndSetOrders() async {
    List<Order> loadedOrders = [];

    final url = Uri.parse(
        "https://book-a-stay-app-default-rtdb.firebaseio.com/orders.json?auth=$authToken");
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      extractedData.forEach((orderId, orderData) {
        if (!isAdmin) {
          if (orderData['userId'] == userId) {
            loadedOrders.add(Order(
                id: orderId,
                userId: orderData['userId'],
                hotelId: orderData['hotelId'],
                checkInDay: DateTime.parse(orderData['checkInDay']),
                checkOutDay: DateTime.parse(orderData['checkOutDay']),
                price: orderData['price'],
                customerCount: orderData['customerCount']));
          }
        } else {
          loadedOrders.add(Order(
              id: orderId,
              userId: orderData['userId'],
              hotelId: orderData['hotelId'],
              checkInDay: DateTime.parse(orderData['checkInDay']),
              checkOutDay: DateTime.parse(orderData['checkOutDay']),
              price: orderData['price'],
              customerCount: orderData['customerCount']));
        }
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future removeOrder(String orderId) async {
    final url = Uri.parse(
        'https://book-a-stay-app-default-rtdb.firebaseio.com/orders/$orderId.json?auth=$authToken');
    final existingOrderIndex =
        _orders.indexWhere((order) => order.id == orderId);
    var existingorder = _orders[existingOrderIndex];
    _orders.removeAt(existingOrderIndex);
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _orders.insert(existingOrderIndex, existingorder);
      notifyListeners();
      throw HttpException("Could not delete order");
    }
  }
}
// https://book-a-stay-app-default-rtdb.firebaseio.com/


