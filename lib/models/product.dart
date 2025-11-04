
class Product {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final int stock;
  final int minStock;
  final int maxStock;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.stock,
    required this.minStock,
    required this.maxStock,
    required this.imageUrl,
  });
}
