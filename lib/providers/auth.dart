import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/api_key.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token as String;
    }
    return '';
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
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
