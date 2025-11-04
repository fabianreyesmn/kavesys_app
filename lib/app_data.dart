
import 'package:flutter/material.dart';
import 'package:kavesys_app/models/product.dart';
import 'package:kavesys_app/models/user.dart';

class AppData extends InheritedWidget {
  final User? user;
  final List<Product> products;
  final Function(Product) updateProduct;
  final Function(Product) addProduct;
  final Function(String) deleteProduct;
  final VoidCallback logout;


  const AppData({
    Key? key,
    required this.user,
    required this.products,
    required this.updateProduct,
    required this.addProduct,
    required this.deleteProduct,
    required this.logout,
    required Widget child,
  }) : super(key: key, child: child);

  static AppData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppData>();
  }

  @override
  bool updateShouldNotify(AppData oldWidget) {
    return user != oldWidget.user || products != oldWidget.products;
  }
}
