import 'package:flutter/material.dart';
import 'my_receipt.dart';

class DeliveryProgressPage extends StatelessWidget {
  final int totalItemCount;
  final double totalPrice;

  const DeliveryProgressPage({
    super.key,
    required this.totalItemCount,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Delivery in progress...",
          style: TextStyle(color: Colors.white, fontFamily: 'PlayfairDisplay'),
        ),
        backgroundColor: const Color(0xFFD3131D),
        centerTitle: true,
      ),
      bottomNavigationBar: _buildBottomNavBar(context, screenWidth),
      body: Padding(
        padding: EdgeInsets.all(screenWidth <= 811 ? 10 : 20),
        child: MyReceipt(
          totalItemCount: totalItemCount,
          totalPrice: totalPrice,
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, double screenWidth) {
    return Container(
      height: screenWidth <= 811 ? 80 : 100,
      decoration: const BoxDecoration(
        color: Color(0xFFD3131D),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.all(screenWidth <= 811 ? 15 : 25),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person),
              color: const Color(0xFFD3131D),
            ),
          ),
          SizedBox(width: screenWidth <= 811 ? 8 : 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact Your",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth <= 811 ? 16 : 19,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Delivery Man",
                  style: TextStyle(
                    fontSize: screenWidth <= 811 ? 14 : 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth <= 811 ? 8 : 10),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                  color: Colors.green,
                ),
              ),
              SizedBox(width: screenWidth <= 811 ? 8 : 10),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.call),
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}