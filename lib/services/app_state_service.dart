
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/movement.dart';
import './api_service.dart';

class AppStateService extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  User? _user;
  bool _isClientView = false;
  bool _showHome = true;
  List<Product> _products = [];
  List<User> _users = [];
  List<Movement> _movements = [];

  User? get user => _user;
  bool get isClientView => _isClientView;
  bool get showHome => _showHome;
  List<Product> get products => _products;
  List<User> get users => _users;
  List<Movement> get movements => _movements;

  AppStateService() {
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      _products = await _apiService.fetchProducts();
      _users = await _apiService.fetchUsers();
      _movements = await _apiService.fetchMovements();
      notifyListeners();
    } catch (e) {
      // Handle error appropriately
      print(e);
    }
  }

  Future<bool> login(String email, String pass) async {
    try {
      final foundUser = await _apiService.login(email, pass);
      _user = foundUser;
      _isClientView = false;
      _showHome = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _user = null;
    _isClientView = false;
    _showHome = true;
    notifyListeners();
  }

  void viewAsClient() {
    _user = null;
    _isClientView = true;
    _showHome = false;
    notifyListeners();
  }

  void exitClientView() {
    _isClientView = false;
    _showHome = true;
    notifyListeners();
  }

  void goToLogin() {
    _showHome = false;
    notifyListeners();
  }

  void goToHome() {
    _showHome = true;
    notifyListeners();
  }

  Future<void> updateProduct(Product updatedProduct) async {
    try {
      final product = await _apiService.updateProduct(updatedProduct);
      _products = _products.map((p) => p.id == product.id ? product : p).toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUser(User updatedUser) async {
    try {
      final user = await _apiService.updateUser(updatedUser);
      _users = _users.map((u) => u.id == user.id ? user : u).toList();
      if (_user?.id == user.id) {
        _user = user;
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addProduct(Product newProduct) async {
    try {
      final product = await _apiService.addProduct(newProduct);
      _products.insert(0, product);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _apiService.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> registerMovement(Movement newMovement) async {
    try {
      final movement = await _apiService.registerMovement(newMovement);
      _movements.insert(0, movement);
      // Optionally, refresh products to get updated stock
      await fetchInitialData(); 
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
