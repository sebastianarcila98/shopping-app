// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../widgets/product_grid.dart';

enum ProductListType { All, Favorite }

class ProductViewScreen extends StatefulWidget {
  static const route = '/products-view';

  @override
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  ProductListType selectedType = ProductListType.All;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping App'),
        actions: [
          PopupMenuButton(
            initialValue: selectedType,
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              setState(() => selectedType = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ProductListType.All,
                child: Text('All'),
              ),
              const PopupMenuItem(
                value: ProductListType.Favorite,
                child: Text('Favorite'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ProductGrid(type: selectedType),
      ),
    );
  }
}
