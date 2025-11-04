
import 'package:flutter/material.dart';
import 'package:kavesys_app/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isClientView;
  final VoidCallback? onClick;

  const ProductCard({
    Key? key,
    required this.product,
    this.isClientView = false,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stockStatus = product.stock < product.minStock
        ? (product.stock == 0 ? 'out' : 'low')
        : 'ok';

    final statusColors = {
      'ok': Colors.green,
      'low': Colors.orange,
      'out': Colors.red,
    };

    final statusText = {
      'ok': '${product.stock} en stock',
      'low': 'Bajo stock: ${product.stock}',
      'out': 'Agotado',
    };

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: isClientView ? null : onClick,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  // Add a placeholder for loading and an error widget for failed loads
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.id,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  if (isClientView)
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: statusColors[stockStatus]!.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        statusText[stockStatus]!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColors[stockStatus],
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
