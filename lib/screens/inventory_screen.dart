import 'package:flutter/material.dart';
import 'package:kavesys_app/app_data.dart';
import 'package:kavesys_app/components/product_card.dart';
import 'package:kavesys_app/models/product.dart';
import 'package:kavesys_app/models/user.dart';
import 'package:kavesys_app/screens/product_editor_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _searchTerm = '';
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final appData = AppData.of(context)!;
    final products = appData.products;
    final user = appData.user;

    final canAddProduct = user?.role == UserRole.administrador || user?.role == UserRole.almacenista;

    final filteredProducts = products.where((product) {
      final matchesFilter = _filter == 'all' ||
          (_filter == 'low' && product.stock < product.minStock) ||
          (_filter == 'out' && product.stock == 0);

      final matchesSearch = _searchTerm.isEmpty ||
          product.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          product.id.toLowerCase().contains(_searchTerm.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar por nombre o código...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchTerm = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilterChip(
                      label: const Text('Todos'),
                      selected: _filter == 'all',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _filter = 'all';
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Stock Bajo'),
                      selected: _filter == 'low',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _filter = 'low';
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Agotados'),
                      selected: _filter == 'out',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _filter = 'out';
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Text('No se encontraron productos.'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductEditorScreen(product: product),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: canAddProduct
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductEditorScreen(),
                  ),
                );
              },
              label: const Text('Añadir'),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }
}