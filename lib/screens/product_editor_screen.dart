import 'package:flutter/material.dart';
import 'package:kavesys_app/app_data.dart';
import 'package:kavesys_app/models/product.dart';
import 'package:kavesys_app/models/user.dart';

class ProductEditorScreen extends StatefulWidget {
  final Product? product;

  const ProductEditorScreen({Key? key, this.product}) : super(key: key);

  @override
  State<ProductEditorScreen> createState() => _ProductEditorScreenState();
}

class _ProductEditorScreenState extends State<ProductEditorScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _category;
  late String _description;
  late double _price;
  late int _stock;
  late int _minStock;
  late int _maxStock;

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? '';
    _category = widget.product?.category ?? '';
    _description = widget.product?.description ?? '';
    _price = widget.product?.price ?? 0;
    _stock = widget.product?.stock ?? 0;
    _minStock = widget.product?.minStock ?? 0;
    _maxStock = widget.product?.maxStock ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final appData = AppData.of(context)!;
    final user = appData.user;
    final isEditMode = widget.product != null;
    final canEdit = user?.role == UserRole.administrador || user?.role == UserRole.almacenista;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Editar Producto' : 'Añadir Producto'),
        actions: [
          if (canEdit)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (isEditMode) {
                    appData.updateProduct(
                      Product(
                        id: widget.product!.id,
                        name: _name,
                        category: _category,
                        description: _description,
                        price: _price,
                        stock: _stock,
                        minStock: _minStock,
                        maxStock: _maxStock,
                        imageUrl: widget.product!.imageUrl,
                      ),
                    );
                  } else {
                    appData.addProduct(
                      Product(
                        id: 'P${DateTime.now().millisecondsSinceEpoch}', // Generate a temporary ID
                        name: _name,
                        category: _category,
                        description: _description,
                        price: _price,
                        stock: _stock,
                        minStock: _minStock,
                        maxStock: _maxStock,
                        imageUrl: 'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/400/400',
                      ),
                    );
                  }
                  Navigator.pop(context);
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isEditMode)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Image.network(widget.product!.imageUrl),
                ),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nombre del Producto'),
                enabled: canEdit,
                validator: (value) => (value == null || value.isEmpty) ? 'Campo requerido' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Categoría'),
                enabled: canEdit,
                validator: (value) => (value == null || value.isEmpty) ? 'Campo requerido' : null,
                onSaved: (value) => _category = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descripción'),
                enabled: canEdit,
                maxLines: 3,
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: 'Precio'),
                enabled: canEdit,
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || double.tryParse(value) == null) ? 'Número inválido' : null,
                onSaved: (value) => _price = double.parse(value!),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _stock.toString(),
                      decoration: const InputDecoration(labelText: 'Stock'),
                      enabled: canEdit,
                      keyboardType: TextInputType.number,
                      validator: (value) => (value == null || int.tryParse(value) == null) ? 'Número inválido' : null,
                      onSaved: (value) => _stock = int.parse(value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _minStock.toString(),
                      decoration: const InputDecoration(labelText: 'Stock Mín.'),
                      enabled: canEdit,
                      keyboardType: TextInputType.number,
                      validator: (value) => (value == null || int.tryParse(value) == null) ? 'Número inválido' : null,
                      onSaved: (value) => _minStock = int.parse(value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      initialValue: _maxStock.toString(),
                      decoration: const InputDecoration(labelText: 'Stock Máx.'),
                      enabled: canEdit,
                      keyboardType: TextInputType.number,
                      validator: (value) => (value == null || int.tryParse(value) == null) ? 'Número inválido' : null,
                      onSaved: (value) => _maxStock = int.parse(value!),
                    ),
                  ),
                ],
              ),
              if (isEditMode && canEdit)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Eliminar Producto'),
                          content: Text('¿Estás seguro de que quieres eliminar "${widget.product!.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                appData.deleteProduct(widget.product!.id);
                                Navigator.pop(context); // Close the dialog
                                Navigator.pop(context); // Go back to the inventory screen
                              },
                              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Eliminar Producto'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}