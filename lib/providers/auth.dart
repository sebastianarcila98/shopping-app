import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_key.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token as String;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${ApiKey.key}');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final extractedData = json.decode(response.body);
      if (extractedData['error'] != null) {
        throw Exception();
      }
      _token = extractedData['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(extractedData['expiresIn'])),
      );
      _userId = extractedData['localId'];
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> signin(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${ApiKey.key}');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final extractedData = json.decode(response.body);
      if (extractedData['error'] != null) {
        throw Exception();
      }
      _token = extractedData['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(extractedData['expiresIn'])),
      );
      _userId = extractedData['localId'];
      _autoSignout();
      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      preferences.setString('userData', userData);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> signout() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();

    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }

  void _autoSignout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpiry), signout);
  }

  Future<bool> tryAutoSignin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('userData')) {
      return false;
    }
    final Map<String, dynamic> extractedData =
        json.decode(preferences.getString('userData') as String);
    final expiryDate = DateTime.parse(extractedData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedData['token'] as String;
    _userId = extractedData['userId'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoSignout();
    return true;
  }
}
