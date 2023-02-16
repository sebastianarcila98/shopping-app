import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // id param is not required because the id of product will always belong to that of the instance that called the method
  Future<void> toggleFavoriteStatus(String? authToken, String? userId) async {
    final url = Uri.parse(
        'https://shopping-app-flutter-b15e6-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken');
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));

      if (response.statusCode >= 400) {
        throw Exception();
      }
    } catch (error) {
      isFavorite = !isFavorite;
      notifyListeners();
      print(error);
      rethrow;
    }
  }
}
