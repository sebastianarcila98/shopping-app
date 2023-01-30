import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/product_details_screen.dart';

import '../models/product.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    return GridTile(
      footer: GridTileBar(
          leading: IconButton(
            onPressed: () {
              product.toggleSavedStatus();
            },
            icon: product.isSaved
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
          backgroundColor: Colors.black54),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed(ProductDetailsScreen.route, arguments: product.id),
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
