import 'package:flutter/material.dart';
import 'package:kavesys_app/app_data.dart';
import 'package:kavesys_app/components/icons.dart';
import 'package:kavesys_app/components/product_card.dart';

class ClientView extends StatelessWidget {
  final VoidCallback onExit;

  const ClientView({Key? key, required this.onExit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appData = AppData.of(context)!;
    final products = appData.products;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: onExit,
        ),
        title: const Row(
          children: [
            KaveLogo(width: 24, height: 24),
            SizedBox(width: 8),
            Text('Catálogo de Productos'),
          ],
        ),
      ),
      body: GridView.builder(
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