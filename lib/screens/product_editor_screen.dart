
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kavesys_app/services/app_state_service.dart';
import 'package:kavesys_app/models/product.dart';
import 'package:kavesys_app/models/user.dart';

// Categories... (keeping the categories map as is)
const Map<String, String> _categories = {
  'AB': 'Abrazadera Toma de Agua',
  'CM': 'Conexión para Manguera',
  'CMH': 'Conexión p/Manguera - Hembra',
  'CMM': 'Conexión p/Manguera - Macho',
  'E': 'Empaque',
  'ECT': 'Contratuerca',
  'EAC': 'Agua-Cal',
  'C': 'Conector Cespol',
  'A': 'Adaptador',
  'AI': 'Adaptador Inserción',
  'AC': 'Adaptador Campana',
  'Cople': 'Cople Inserción',
  'T': 'Tee',
  'TI': 'Tee de Inserción',
  'TCM': 'Tee Macho',
  'TCH': 'Tee Hembra',
  'R': 'Regatón',
  'RPB': 'Regatón para Bastón',
  'RRE': 'Regatón Redondo Exterior',
  'RCE': 'Regatón Cuadrado Exterior',
  'RRI': 'Regatón Redondo Interior',
  'RCI': 'Regatón Cuadrado Interior',
  'RM': 'Regatón para Muleta',
  'RI': 'Regatón Interior',
  'Y': 'Y Griega de Inserción',
  'CD': 'Codo',
  'CDI': 'Codo de Inserción',
  'CRI': 'Codo Rosca Interior',
  'CRE': 'Codo Rosca Exterior',
  'X': 'Cruz Inserción',
  'TP': 'Tapón',
  'TA': 'Tapón Inserción',
  'TM': 'Tapón Macho',
  'TH': 'Tapón Hembra',
  'TL': 'Tapón para Lavabo',
  'N': 'Nivelador',
  'TN': 'Tornillo Nivelador',
  'TO': 'Tope',
  'BT': 'Brida para Tinaco',
  'CU': 'Cuña para puerta',
  'VN': 'Válvula',
  'VNX': 'Válvula Nariz',
  'VNG': 'Válvula para Garrafón',
  'S': 'Separador de Piso',
  'RB': 'Reducción Bushing',
  'CT': 'Contratuerca'
};

class ProductEditorScreen extends StatefulWidget {
  final Product? product;

  const ProductEditorScreen({Key? key, this.product}) : super(key: key);

  @override
  State<ProductEditorScreen> createState() => _ProductEditorScreenState();
}

class _ProductEditorScreenState extends State<ProductEditorScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _code;
  late String _name;
  late String _category;
  late String _description;
  late double _price;
  late int _stock;
  late int _minStock;
  late int _maxStock;
  late int _piecesPerBag;

  @override
  void initState() {
    super.initState();
    _code = widget.product?.code ?? '';
    _name = widget.product?.name ?? '';
    _description = widget.product?.description ?? '';
    _price = widget.product?.price ?? 0;
    _stock = widget.product?.stock ?? 0;
    _minStock = widget.product?.minStock ?? 0;
    _maxStock = widget.product?.maxStock ?? 0;
    _piecesPerBag = widget.product?.piecesPerBag ?? 1;

    final categoryValue = widget.product?.category;
    String categoryKey = _categories.keys.first;
    if (categoryValue != null) {
      if (_categories.containsKey(categoryValue)) {
        categoryKey = categoryValue;
      } else {
        final entry = _categories.entries.firstWhere(
              (entry) => entry.value == categoryValue,
          orElse: () => _categories.entries.first,
        );
        categoryKey = entry.key;
      }
    }
    _category = categoryKey;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateService>(context, listen: false);
    final user = appState.user;
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
                  final product = Product(
                    id: widget.product?.id ?? '',
                    code: _code,
                    name: _name,
                    category: _category,
                    description: _description,
                    price: _price,
                    stock: _stock,
                    minStock: _minStock,
                    maxStock: _maxStock,
                    piecesPerBag: _piecesPerBag,
                    imageUrl: widget.product?.imageUrl ?? 'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/400/400',
                  );

                  final future = isEditMode
                      ? appState.updateProduct(product)
                      : appState.addProduct(product);

                  future.then((_) => Navigator.pop(context));
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
                initialValue: _code,
                decoration: const InputDecoration(labelText: 'Clave'),
                enabled: canEdit,
                validator: (value) => (value == null || value.isEmpty) ? 'Campo requerido' : null,
                onSaved: (value) => _code = value!,
              ),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nombre del Producto'),
                enabled: canEdit,
                validator: (value) => (value == null || value.isEmpty) ? 'Campo requerido' : null,
                onSaved: (value) => _name = value!,
              ),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: _categories.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: canEdit ? (value) {
                  setState(() {
                    _category = value!;
                  });
                } : null,
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
                initialValue: _piecesPerBag.toString(),
                decoration: const InputDecoration(labelText: 'Piezas por bolsa'),
                enabled: canEdit,
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || int.tryParse(value) == null || int.parse(value!) <= 0) ? 'Número inválido' : null,
                onSaved: (value) => _piecesPerBag = int.parse(value!),
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
                                appState.deleteProduct(widget.product!.id).then((_) {
                                  Navigator.pop(context); // Close the dialog
                                  Navigator.pop(context); // Go back to the inventory screen
                                });
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
