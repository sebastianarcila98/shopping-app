import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/products_overview_screen.dart';
import './screens/auth_screen.dart';

import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import 'providers/auth.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products(),
            update: (ctx, auth, prevProducts) => prevProducts!..update(auth),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders(),
            update: (ctx, auth, prevOrders) => prevOrders!..update(auth),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MyShop',
              theme: ThemeData(
                fontFamily: 'Lato',
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                        .copyWith(secondary: Colors.deepOrange),
              ),
              home: auth.isAuth
                  ? const ProductsOverviewScreen()
                  : const AuthScreen(),
              routes: {
                ProductDetailScreen.routeName: (ctx) =>
                    const ProductDetailScreen(),
                CartScreen.routeName: (ctx) => const CartScreen(),
                OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                UserProductsScreen.routeName: (ctx) =>
                    const UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => const EditProductScreen(),
              }),
        ));
  }
}
