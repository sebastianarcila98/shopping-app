import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isSaved;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isSaved = false,
  });

  void toggleSavedStatus() {
    isSaved = !isSaved;
    notifyListeners();
  }
}
