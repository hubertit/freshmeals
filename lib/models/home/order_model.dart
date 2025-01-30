class OrdersModel {
  final int orderId;
  final double totalPrice;
  final DateTime orderDate;
  final String status;
  final String? comment;
  final String imageUrl;

  OrdersModel({
    required this.orderId,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
    this.comment,
    required this.imageUrl,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return OrdersModel(
      orderId: json['order_id'],
      totalPrice: double.parse(json['total_price']),
      orderDate: DateTime.parse(json['order_date']),
      status: json['status'],
      comment: json['comment'],
      imageUrl: json['image_url']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'total_price': totalPrice.toStringAsFixed(2),
      'order_date': orderDate.toIso8601String(),
      'status': status,
      'comment': comment,
      'image_url': imageUrl,
    };
  }
}
