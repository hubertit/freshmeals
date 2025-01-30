class OrderDetails {
  final int orderId;
  final String totalPrice;
  final String orderDate;
  final String status;
  final String comment;
  final DeliveryAddress deliveryAddress;
  final List<OrderItem> items;

  OrderDetails({
    required this.orderId,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
    required this.comment,
    required this.deliveryAddress,
    required this.items,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      orderId: json['order_id'] ?? 0,
      totalPrice: json['total_price'] ?? "",
      orderDate: json['order_date'] ?? "",
      status: json['status'] ?? "",
      comment: json['comment'] ?? "",
      deliveryAddress: DeliveryAddress.fromJson(json['delivery_address']),
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}

class DeliveryAddress {
  final String streetNumber;
  final String houseNumber;
  final String mapAddress;

  DeliveryAddress({
    required this.streetNumber,
    required this.houseNumber,
    required this.mapAddress,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      streetNumber: json['street_number']??"",
      houseNumber: json['house_number']??"",
      mapAddress: json['map_address']??"",
    );
  }
}

class OrderItem {
  final int mealId;
  final String name;
  final int quantity;
  final String price;
  final String imageUrl;

  OrderItem({
    required this.mealId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      mealId: json['meal_id'] ?? 0,
      name: json['name'] ?? "",
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? "",
      imageUrl: json['image_url'] ?? "",
    );
  }
}
