import 'package:flutter/material.dart';
import 'package:kavesys_app/components/icons.dart';
import 'package:kavesys_app/models/product.dart';
import 'package:kavesys_app/services/api_service.dart';
import 'package:kavesys_app/components/product_card.dart';

class ClientView extends StatefulWidget {
  final VoidCallback onExit;

  const ClientView({Key? key, required this.onExit}) : super(key: key);

  @override
  State<ClientView> createState() => _ClientViewState();
}

class _ClientViewState extends State<ClientView> {
  final ApiService _apiService = ApiService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _apiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: widget.onExit,
        ),
        title: const Row(
          children: [
            KaveLogo(width: 24, height: 24),
            SizedBox(width: 8),
            Text('Catálogo de Productos'),
          ],
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron productos.'));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  isClientView: true,
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('© 2025 Plásticos KAVE S.A. de C.V.', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text('Av. Héroes de Nacozari Nte. 2406', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}