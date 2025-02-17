class PaymentsModel {
  final int paymentId;
  final int? orderId;
  final int subscriptionId;
  final String paymentReference;
  final String amount;
  final String currency;
  final String paymentMethod;
  final String paymentType;
  final String status;
  final String transactionDate;
  final String? description;
  final String paymentUrl;

  PaymentsModel({
    required this.paymentId,
    this.orderId,
    required this.subscriptionId,
    required this.paymentReference,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.paymentType,
    required this.status,
    required this.transactionDate,
    required this.paymentUrl,
    this.description,

  });

  // Factory constructor to create a Payment instance from JSON
  factory PaymentsModel.fromJson(Map<String, dynamic> json) {
    return PaymentsModel(
      paymentId: json['payment_id'] ?? 0, // Default to 0 if null
      orderId: json['order_id'], // Nullable, so no default needed
      subscriptionId: json['subscription_id'] ?? 0, // Default to 0 if null
      paymentReference: json['payment_reference'] ?? 'N/A', // Default string if null
      amount: json['amount'] ?? '0.00', // Default to "0.00" if null
      currency: json['currency'] ?? 'Unknown', // Default currency
      paymentMethod: json['payment_method'] ?? 'Unknown', // Default payment method
      paymentType: json['payment_type'] ?? 'Unknown', // Default payment type
      status: json['status'] ?? 'Unknown', // Default status
      transactionDate: json['transaction_date'] ?? '1970-01-01 00:00:00', // Default date if null
      description: json['description'], // Nullable, no default needed
      paymentUrl: json['payment_url']
    );
  }

  // Method to convert Payment instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'order_id': orderId,
      'subscription_id': subscriptionId,
      'payment_reference': paymentReference,
      'amount': amount,
      'currency': currency,
      'payment_method': paymentMethod,
      'payment_type': paymentType,
      'status': status,
      'transaction_date': transactionDate,
      'description': description,
    };
  }
}
