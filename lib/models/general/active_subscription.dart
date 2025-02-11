class ActiveSubscription {
  final int subscriptionId;
  final String name;
  final String description;
  final String price;
  final int duration;
  final String startDate;
  final String endDate;
  final String status;

  ActiveSubscription({
    required this.subscriptionId,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory ActiveSubscription.fromJson(Map<String, dynamic> json) {
    return ActiveSubscription(
      subscriptionId: json['subscription_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      duration: json['duration'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
    );
  }
}
