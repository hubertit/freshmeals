import 'meal_model.dart';

class CartItem {
  final int cartId;
  final int mealId;
  final String mealName;
  final String imageUrl;
  final int quantity;
  final double price;
  final double totalPrice;
  final DateTime addedAt;

  CartItem({
    required this.cartId,
    required this.mealId,
    required this.mealName,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    required this.addedAt,
  });

  // Factory constructor for creating a CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartId: json['cart_id'] as int,
      mealId: json['meal_id'] as int,
      mealName: json['meal_name'] as String,
      imageUrl: json['image_url'] as String,
      quantity: json['quantity'] as int,
      price: double.tryParse(json['price'] as String) ?? 0.0,
      totalPrice: double.tryParse(json['total_price'] as String) ?? 0.0,
      addedAt: DateTime.parse(json['added_at'] as String),
    );
  }

  // Method to convert CartItem back to JSON
  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'meal_id': mealId,
      'meal_name': mealName,
      'image_url': imageUrl,
      'quantity': quantity,
      'price': price.toStringAsFixed(2),
      'total_price': totalPrice.toStringAsFixed(2),
      'added_at': addedAt.toIso8601String(),
    };
  }
}
