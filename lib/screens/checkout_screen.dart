import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';

class CheckoutScreen extends StatelessWidget {
  static const route = '/checkout-screen';

  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  '\$${cart.totalAmount}',
                  style: const TextStyle(fontSize: 20),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    cart.clear();
                  },
                  child: const Text('Order now'),
                )
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(cartItems[index].id),
                    background:
                        Container(color: Theme.of(context).colorScheme.error),
                    direction: DismissDirection.endToStart,
                    secondaryBackground: const Icon(Icons.delete),
                    onDismissed: (direction) {
                      cart.removeItem(cartItems[index].id);
                    },
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: FittedBox(
                                child: Text('\$${cartItems[index].price}'),
                              ),
                            ),
                          ),
                          title: Text(cartItems[index].title),
                          trailing: Text('x${cartItems[index].quantity}'),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
