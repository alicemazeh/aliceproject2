class FoodItem {
  final String name;
  final double price;
  final String image;
  final String category;

  FoodItem({
    required this.name,
    required this.price,
    required this.image,
    required this.category,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      category: json['category'] as String,
    );
  }
}

class CartItem {
  final FoodItem foodItem;
  int quantity;
  CartItem({required this.foodItem, this.quantity = 1});
}