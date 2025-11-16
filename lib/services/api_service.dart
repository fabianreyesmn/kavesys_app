
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/user.dart';
import '../models/movement.dart';

class ApiService {
  static const String _baseUrl = 'http://10.13.202.217:3000';

  // Product Methods
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/catalogo'));
    if (response.statusCode == 200) {
      final List<dynamic> productList = json.decode(response.body);
      return productList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/alta-producto'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<Product> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/actualizar-producto/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(String productId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/eliminar-producto/$productId'));
    if (response.statusCode != 200) { // Backend returns 200 for success
      throw Exception('Failed to delete product');
    }
  }

  // User Methods
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/usuarios'));
    if (response.statusCode == 200) {
      final List<dynamic> userList = json.decode(response.body);
      return userList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/actualizar_rol'), // Assuming only role update for now
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': user.id, 'newRole': user.role.toString().split('.').last}),
    );
    if (response.statusCode == 200) {
      // Backend returns a message, not the updated user. Fetch users again to get updated data.
      // For simplicity, we'll just return the original user for now.
      return user;
    } else {
      throw Exception('Failed to update user');
    }
  }

  // Movement Methods
  Future<List<Movement>> fetchMovements() async {
    final response = await http.get(Uri.parse('$_baseUrl/gestion/movimientos'));
    if (response.statusCode == 200) {
      final List<dynamic> movementList = json.decode(response.body);
      return movementList.map((json) => Movement.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movements');
    }
  }

  Future<Movement> registerMovement(Movement movement) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/gestion/movimiento'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(movement.toJson()),
    );
    if (response.statusCode == 201) {
      return Movement.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register movement');
    }
  }

  // Auth Methods (Simplified for testing)
  Future<User> login(String email, String password) async {
    // This is a dummy login for now, as the backend uses token-based auth.
    // In a real app, you'd integrate with Firebase Auth or a similar service.
    if (email == 'admin@kave.com' && password == 'password') {
      return User(id: 1, name: 'Admin User', role: UserRole.administrador, email: email);
    } else if (email == 'almacen@kave.com' && password == 'password') {
      return User(id: 2, name: 'Almacenista User', role: UserRole.almacenista, email: email);
    } else if (email == 'ventas@kave.com' && password == 'password') {
      return User(id: 3, name: 'Vendedor User', role: UserRole.vendedor, email: email);
    } else {
      throw Exception('Invalid credentials');
    }
  }
}
