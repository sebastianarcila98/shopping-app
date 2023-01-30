import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const route = '/product-details';

  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<ProductsProvider>(context).products;
    var productId = ModalRoute.of(context)?.settings.arguments;

    Product product = products.firstWhere((p) => p.id == productId);
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Column(
        children: [
          Hero(
            tag: 'hero-rectangle',
            child: Image.network(product.imageUrl),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(product.description),
          )
        ],
      ),
    );
  }
}
