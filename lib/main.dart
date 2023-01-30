// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/products_provider.dart';
import './screens/product_details_screen.dart';

import 'screens/products_view_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ProductViewScreen(),
        
        routes: {
          ProductViewScreen.route: (context) => ProductViewScreen(),
          ProductDetailsScreen.route: (context) => ProductDetailsScreen(),
        },
      ),
    );
  }
}
