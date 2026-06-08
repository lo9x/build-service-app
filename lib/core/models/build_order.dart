class BuildOrder {
  const BuildOrder({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
    required this.city,
    required this.category,
    required this.customerId,
    required this.status,
    this.customerName,
  });

  final String id;
  final String title;
  final String description;
  final double budget;
  final String city;
  final String category;
  final String customerId;
  final String status;
  final String? customerName;

  factory BuildOrder.fromJson(Map<String, dynamic> json) {
    return BuildOrder(
      id: json['id'].toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      budget: (json['budget'] as num?)?.toDouble() ?? 0,
      city: (json['city'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      customerId: (json['customerId'] ?? '').toString(),
      status: (json['status'] ?? 'open').toString(),
      customerName: json['customerName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'budget': budget,
      'city': city,
      'category': category,
      'customerId': customerId,
      'status': status,
      'customerName': customerName,
    };
  }
}
