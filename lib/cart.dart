import 'package:flutter/material.dart';
import 'item_menu.dart';
import 'information.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override

  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<CartItem> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.cartItems);
  }

  void _removeItem(int index) {
    setState(() {
      final item = _cartItems[index];
      if (item.quantity > 1) {
        item.quantity--;
      } else {

        _cartItems.removeAt(index);
      }
    });
  }

  void _handleOrderNow() {
    if (_cartItems.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Empty Cart'),
            content: const Text('Add items to cart before placing an order.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      double totalPrice = _cartItems.fold(0, (sum, item) => sum + item.foodItem.price * item.quantity);
      int totalItemCount = _cartItems.fold(0, (sum, item) => sum + item.quantity);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PersonalInfo(
            totalItemCount: totalItemCount,
            totalPrice: totalPrice,
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    double totalPrice = _cartItems.fold(0, (sum, item) => sum + item.foodItem.price * item.quantity);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Cart', style: TextStyle(fontFamily: 'PlayfairDisplay', color: Colors.white)),
        backgroundColor: const Color(0xFFD3131D),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _cartItems.isEmpty
                  ? const Center(
                child: Text(
                  'No items in cart',
                  style: TextStyle(fontSize: 18, fontFamily: 'PlayfairDisplay',fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.builder(
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  final item = _cartItems[index];
                  return ListTile(
                    leading: Image.asset(item.foodItem.image, width: 50.0, height: 50.0),
                    title: Text(item.foodItem.name),
                    subtitle: Text('\$${item.foodItem.price.toStringAsFixed(2)} x ${item.quantity}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('\$${(item.foodItem.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontFamily: 'PlayfairDisplay')),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _removeItem(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            if (_cartItems.isNotEmpty) ...[
              Text(
                'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'PlayfairDisplay'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) => const Color(0xFFD3131D),
                    ),
                  ),
                  onPressed: _handleOrderNow,
                  child: const Text('Order Now', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}