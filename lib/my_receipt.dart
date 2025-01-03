import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyReceipt extends StatelessWidget {
  final int totalItemCount;
  final double totalPrice;

  const MyReceipt({
    super.key,
    required this.totalItemCount,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Thank You For Choosing Us!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(9),
                ),
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Text(
                    _generateReceipt(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your Order Is On Its Way..",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _generateReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Your Receipt:");
    receipt.writeln();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("----------");
    receipt.writeln("----------");
    receipt.writeln("Total Items: $totalItemCount");
    receipt.writeln("Total Price: \$${totalPrice.toStringAsFixed(2)}");
    receipt.writeln();
    return receipt.toString();
  }
}