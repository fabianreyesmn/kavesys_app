import 'package:flutter/material.dart';
import 'package:kavesys_app/models/product.dart';
import 'package:kavesys_app/models/user.dart';
import 'package:kavesys_app/screens/client_view.dart';
import 'package:kavesys_app/screens/login_screen.dart';
import 'package:kavesys_app/app_data.dart';
import 'package:kavesys_app/screens/main_layout.dart';
import 'package:kavesys_app/app_data.dart';

void main() {
  runApp(const App());
}

// Mock Data
final List<User> mockUsers = [
  User(id: 1, name: 'Daniel Avendaño', role: UserRole.administrador, email: 'admin@kave.com'),
  User(id: 2, name: 'Pedro García', role: UserRole.almacenista, email: 'almacen@kave.com'),
  User(id: 3, name: 'Fabián Reyes', role: UserRole.vendedor, email: 'ventas@kave.com'),
];

final List<Product> mockProducts = [
    Product(id: 'P001', name: 'Conexión para Duraducto 1/2"', category: 'Conexiones', description: 'Conexión de inserción para duraducto de media pulgada.', price: 5.50, stock: 1500, minStock: 200, maxStock: 2000, imageUrl: 'https://picsum.photos/seed/P001/400/400'),
    Product(id: 'P002', name: 'Tapón para Silla 1"', category: 'Tapones', description: 'Tapón redondo de una pulgada para patas de silla.', price: 2.75, stock: 850, minStock: 150, maxStock: 1500, imageUrl: 'https://picsum.photos/seed/P002/400/400'),
    Product(id: 'P003', name: 'Regatón Rectangular', category: 'Regatones', description: 'Regatón de plástico para perfiles rectangulares.', price: 3.20, stock: 150, minStock: 100, maxStock: 1000, imageUrl: 'https://picsum.photos/seed/P003/400/400'),
    Product(id: 'P004', name: 'Ancla para Concreto', category: 'Ferretería', description: 'Artículo de ferretería para fijación en concreto.', price: 8.00, stock: 400, minStock: 50, maxStock: 500, imageUrl: 'https://picsum.photos/seed/P004/400/400'),
    Product(id: 'P005', name: 'Conexión para Duraducto 3/4"', category: 'Conexiones', description: 'Conexión de inserción para duraducto de tres cuartos.', price: 7.25, stock: 30, minStock: 50, maxStock: 1500, imageUrl: 'https://picsum.photos/seed/P005/400/400'),
];


class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  User? _user;
  bool _isClientView = false;
  List<Product> _products = mockProducts;

  bool _login(String email, String pass) {
    // Mock login logic
    try {
      final foundUser = mockUsers.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
      if (pass == 'password') { // Use a fixed password for demo
        setState(() {
          _user = foundUser;
          _isClientView = false;
        });
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  void _logout() {
    setState(() {
      _user = null;
      _isClientView = false;
    });
  }

  void _viewAsClient() {
    setState(() {
      _user = null;
      _isClientView = true;
    });
  }

  void _exitClientView() {
    setState(() {
      _isClientView = false;
    });
  }

  void _updateProduct(Product updatedProduct) {
    setState(() {
      _products = _products.map((p) => p.id == updatedProduct.id ? updatedProduct : p).toList();
    });
  }

  void _addProduct(Product newProduct) {
    setState(() {
      _products.insert(0, newProduct);
    });
  }

  void _deleteProduct(String productId) {
    setState(() {
      _products.removeWhere((p) => p.id == productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppData(
      user: _user,
      products: _products,
      updateProduct: _updateProduct,
      addProduct: (Product newProduct) => _addProduct(newProduct),
      deleteProduct: _deleteProduct,
      logout: _logout,
      child: MaterialApp(
        title: 'KaveSys',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'sans-serif',
        ),
        home: _isClientView
            ? ClientView(onExit: _exitClientView)
            : _user != null
                ? const MainLayout()
                : LoginScreen(
                    onClientView: _viewAsClient,
                    onLogin: _login,
                  ),
      ),
    );
  }
}