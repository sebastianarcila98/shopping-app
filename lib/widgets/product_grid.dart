import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/products_view_screen.dart';
import '../providers/products_provider.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  final ProductListType type;
  const ProductGrid({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = type == ProductListType.All
        ? productsProvider.products
        : productsProvider.products.where((p) => p.isSaved).toList();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: const ProductItem(),
        );
      },
    );
  }
}
