class OrderResponse {
  const OrderResponse({
    required this.id,
    required this.orderId,
    required this.specialistId,
    required this.message,
    required this.price,
    required this.status,
    this.specialistName,
  });

  final String id;
  final String orderId;
  final String specialistId;
  final String message;
  final double price;
  final String status;
  final String? specialistName;

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['id'].toString(),
      orderId: (json['orderId'] ?? '').toString(),
      specialistId: (json['specialistId'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      status: (json['status'] ?? 'new').toString(),
      specialistName: json['specialistName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'specialistId': specialistId,
      'message': message,
      'price': price,
      'status': status,
      'specialistName': specialistName,
    };
  }
}
