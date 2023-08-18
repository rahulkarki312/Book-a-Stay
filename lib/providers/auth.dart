// admin username: admin@test.com, pw: admin123

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exceptions.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  String? _emailAddress;
  bool _isAdmin = false; // flag to indicate if the user is admin

  bool get isAuth {
    return token != null;
  }

  bool get isAdmin {
    return _isAdmin;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  String? get emailAddress {
    if (_token != null) {
      return _emailAddress;
    }
    return "";
  }

  Future<void> _authenticate(String email, String password, String urlSegment,
      {bool loginAsAdmin = false}) async {
    // the url for requesting sign up / sign in is done using firebase's REST API,
    // which provides the endpoint to send the request (email ,
    //password and requestSecureToken) with the API key of a realtime database (here firebase itself)

    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCrrPrZJkWTwtaL5xBfgd5oPs_GoEZFDeE");
    try {
      if (loginAsAdmin) {
        if (email != "admin@test.com") {
          throw HttpException("Not an admin account !");
        }
      }
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      // print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      // if no error occurs / the user is authenticated
      _token = responseData['idToken'];
      print("token: $_token ");
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _emailAddress = email;

      if (loginAsAdmin) {
        _isAdmin = true;
      }

      // print(_expiryDate);
      _autoLogout();
      notifyListeners();

      // On-device storage using shared_preferences

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
        'email': email,
        'isAdmin': isAdmin
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> loginAdmin(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword",
        loginAsAdmin: true);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print("Not written yet");
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')!); //as Map<String, Object>
    print("logged in user by auto login: " +
        extractedUserData['email'] +
        " isAdmin: " +
        extractedUserData['isAdmin']
            .toString()); //to check the user's stored info

    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'].toString());

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _emailAddress = extractedUserData['email'].toString();
    _token = extractedUserData['token'].toString();
    _userId = extractedUserData['userId'].toString();
    _expiryDate = expiryDate;
    _isAdmin = extractedUserData['isAdmin'];

    notifyListeners(); //this automatically rebuilds the home screen since the 'auth' provider's values has been changed/set
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    _isAdmin = false;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;

    _authTimer = Timer(
        Duration(
          seconds: timeToExpiry,
        ),
        logout);
  }
}
