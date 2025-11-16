
class Product {
  final String id;
  final String code;
  final String name;
  final String category;
  final String description;
  final double price;
  final int stock;
  final int minStock;
  final int maxStock;
  final int piecesPerBag;
  final String imageUrl;

  Product({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.stock,
    required this.minStock,
    required this.maxStock,
    required this.piecesPerBag,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['ID_Inventario']?.toString() ?? '',
      code: json['Clave']?.toString() ?? '',
      name: json['Descripcion']?.toString() ?? '',
      category: json['ID_Categoria']?.toString() ?? '',
      description: json['Descripcion']?.toString() ?? '',
      price: double.tryParse(json['Precio']?.toString() ?? '0.0') ?? 0.0,
      stock: int.tryParse(json['Existencias']?.toString() ?? '0') ?? 0,
      minStock: int.tryParse(json['ExistenciasMinimas']?.toString() ?? '0') ?? 0,
      maxStock: int.tryParse(json['ExistenciasMaximas']?.toString() ?? '0') ?? 0,
      piecesPerBag: int.tryParse(json['Piezas']?.toString() ?? '0') ?? 0,
      imageUrl: 'https://picsum.photos/seed/${json['ID_Inventario']}/400/400',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'stock': stock,
      'minStock': minStock,
      'maxStock': maxStock,
      'piecesPerBag': piecesPerBag,
      'imageUrl': imageUrl,
    };
  }
}
