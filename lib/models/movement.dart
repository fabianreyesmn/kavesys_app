
class Movement {
  final String id;
  final String productId;
  final DateTime date;
  final String type; // 'entrada' or 'salida'
  final int quantity;
  final int stockActual;

  Movement({
    required this.id,
    required this.productId,
    required this.date,
    required this.type,
    required this.quantity,
    required this.stockActual,
  });

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      id: json['_id'] ?? '',
      productId: json['productId'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      type: json['type'] ?? '',
      quantity: json['quantity'] ?? 0,
      stockActual: json['stockActual'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'date': date.toIso8601String(),
      'type': type,
      'quantity': quantity,
      'stockActual': stockActual,
    };
  }
}
