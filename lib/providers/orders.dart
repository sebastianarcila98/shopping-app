import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './auth.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String? authToken;
  String? userId;

  List<OrderItem> get orders {
    return [..._orders];
  }

  void update(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

  Future<void> getOrders() async {
    final url = Uri.parse(
        'https://shopping-app-flutter-b15e6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    if (response.body == null) return;
    Map<String, dynamic> extractedData = json.decode(response.body);
    List<OrderItem> loadedOrders = [];
    extractedData.forEach((key, value) {
      loadedOrders.insert(
        0,
        OrderItem(
          id: key,
          amount: value['amount'],
          dateTime: DateTime.parse(value['dateTime']),
          products: (value['products'] as List<dynamic>)
              .map((items) => CartItem(
                  id: items['id'],
                  title: items['title'],
                  quantity: items['quantity'],
                  price: items['price']))
              .toList(),
        ),
      );
      _orders = loadedOrders;
      notifyListeners();
    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, double totalAmount) async {
    final url = Uri.parse(
        'https://shopping-app-flutter-b15e6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    // creating var with current time allows us to have a consistent time in the server as well as front end when we display the timestamp
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': totalAmount,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: totalAmount,
          dateTime: timestamp,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
