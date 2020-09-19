import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop/models/HttpException.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    } else
      return null;
  }

  Future<void> signIn(String email, String password) async {
    var url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCDDpKexBEuNIFXTTjqIGwQVWqjEQQZmKA";
    return http
        .post(url,
            body: json.encode({
              "email": email,
              "password": password,
              "returnSecureToken": true,
            }))
        .then((response) async {
      var extract = json.decode(response.body);
      if (extract["error"] != null) {
        throw HttpException(extract["error"]["message"]);
      } else {
        _token = extract["idToken"];
        _userId = extract["localId"];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(extract["expiresIn"])));
      }
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();

      final userDate = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String()
      });

      prefs.setString("userData", userDate);
    });
  }

  Future<void> signUp(String email, String password) {
    var url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCDDpKexBEuNIFXTTjqIGwQVWqjEQQZmKA";

    return http
        .post(url,
            body: json.encode({
              "email": email,
              "password": password,
              "returnSecureToken": true,
            }))
        .then((response) {
      var extract = json.decode(response.body);
      if (extract["error"] != null) {
        throw HttpException(extract["error"]["message"]);
      } else {
        _token = extract["idToken"];
        _userId = extract["localId"];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(extract["expiresIn"])));
      }
      notifyListeners();
    });
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }

    final extractUserData =
        json.decode(prefs.getString("userData")) as Map<String, dynamic>;

    final expiryDate = DateTime.parse(extractUserData["expiryDate"]);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractUserData["token"];
    _userId = extractUserData["userId"];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

 Future <void> logout() async{
    _expiryDate = null;
    _userId = null;
    _token = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }
}
/*
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyC13spCwP_f_SalxEbkB-wjedoF8iYENlQ';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }
}

 */
