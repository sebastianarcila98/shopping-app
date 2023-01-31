// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/checkout_screen.dart';
import './providers/products_provider.dart';
import './screens/product_details_screen.dart';

import 'providers/cart_provider.dart';
import 'screens/products_view_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ProductViewScreen(),
        routes: {
          ProductViewScreen.route: (context) => ProductViewScreen(),
          ProductDetailsScreen.route: (context) => ProductDetailsScreen(),
          CheckoutScreen.route: (context) => CheckoutScreen(),
        },
      ),
    );
  }
}
