import 'package:flutter/material.dart';
import 'package:kavesys_app/components/icons.dart';
import 'package:kavesys_app/screens/dashboard_screen.dart';
import 'package:kavesys_app/screens/inventory_screen.dart';
import 'package:kavesys_app/screens/profile_screen.dart';
import 'package:kavesys_app/screens/reports_screen.dart';
import 'package:kavesys_app/app_data.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    InventoryScreen(),
    ReportsScreen(),
    ProfileScreen(),
  ];

  static const List<String> _widgetTitles = <String>[
    'Dashboard',
    'Inventario',
    'Reportes',
    'Mi Perfil',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appData = AppData.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const KaveLogo(width: 24, height: 24),
            const SizedBox(width: 8),
            Text(_widgetTitles.elementAt(_selectedIndex)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: appData.logout,
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reportes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}