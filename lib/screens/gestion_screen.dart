
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kavesys_app/services/app_state_service.dart';
import 'package:kavesys_app/models/product.dart';
import 'package:kavesys_app/models/movement.dart';
import 'package:intl/intl.dart';

class GestionScreen extends StatefulWidget {
  const GestionScreen({Key? key}) : super(key: key);

  @override
  _GestionScreenState createState() => _GestionScreenState();
}

class _GestionScreenState extends State<GestionScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProductId;
  String _movementType = 'entrada';
  DateTime _selectedDate = DateTime.now();
  int _quantity = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _registerMovement(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final appState = Provider.of<AppStateService>(context, listen: false);
      if (_selectedProductId == null) return;

      final product = appState.products.firstWhere((p) => p.id == _selectedProductId);
      int newStock = product.stock;
      if (_movementType == 'entrada') {
        newStock += _quantity;
      } else if (_movementType == 'salida') {
        newStock -= _quantity;
      }

      if (newStock < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay suficiente stock para esta salida.')),
        );
        return;
      }

      final newMovement = Movement(
        id: '', // The backend will generate the ID
        productId: _selectedProductId!,
        date: _selectedDate,
        type: _movementType,
        quantity: _quantity,
        stockActual: newStock,
      );

      appState.registerMovement(newMovement).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Movimiento registrado exitosamente.')),
        );
        _formKey.currentState!.reset();
        setState(() {
          _selectedProductId = null;
          _movementType = 'entrada';
          _selectedDate = DateTime.now();
          _quantity = 0;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar el movimiento: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateService>(
      builder: (context, appState, child) {
        final products = appState.products;
        final movements = appState.movements;

        Product? getProductById(String productId) {
          try {
            return products.firstWhere((p) => p.id == productId);
          } catch (e) {
            return null;
          }
        }

        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registrar Movimiento',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Producto', border: OutlineInputBorder()),
                        value: _selectedProductId,
                        isExpanded: true,
                        items: products.map((product) {
                          return DropdownMenuItem(
                            value: product.id,
                            child: Text(
                              '${product.name} (Stock: ${product.stock})',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedProductId = value;
                          });
                        },
                        validator: (value) => value == null ? 'Selecciona un producto' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(labelText: 'Tipo', border: OutlineInputBorder()),
                              value: _movementType,
                              items: const [
                                DropdownMenuItem(value: 'entrada', child: Text('Entrada')),
                                DropdownMenuItem(value: 'salida', child: Text('Salida')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _movementType = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Cantidad',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              initialValue: _quantity.toString(),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Ingresa la cantidad';
                                if (int.tryParse(value) == null || int.parse(value) <= 0) return 'Cantidad inválida';
                                return null;
                              },
                              onSaved: (value) {
                                _quantity = int.parse(value!);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Fecha',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                            validator: (value) => value == null || value.isEmpty ? 'Selecciona una fecha' : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: products.isEmpty ? null : () => _registerMovement(context),
                        child: const Text('Registrar'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Últimos Movimientos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: movements.isEmpty
                    ? const Center(child: Text('No hay movimientos registrados.'))
                    : ListView.builder(
                        itemCount: movements.length,
                        itemBuilder: (context, index) {
                          final movement = movements[index];
                          final product = getProductById(movement.productId);
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: ListTile(
                              title: Text(product?.name ?? 'Producto Desconocido'),
                              subtitle: Text(
                                  '${DateFormat('yyyy-MM-dd').format(movement.date)} - ${movement.type == 'entrada' ? 'Entrada' : 'Salida'} de ${movement.quantity} unidades'),
                              trailing: Text('Stock: ${movement.stockActual}'),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
