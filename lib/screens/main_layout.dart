
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kavesys_app/components/icons.dart';
import 'package:kavesys_app/models/user.dart';
import 'package:kavesys_app/screens/contact_screen.dart';
import 'package:kavesys_app/screens/dashboard_screen.dart';
import 'package:kavesys_app/screens/gestion_screen.dart';
import 'package:kavesys_app/screens/inventory_screen.dart';
import 'package:kavesys_app/screens/profile_screen.dart';
import 'package:kavesys_app/screens/reports_screen.dart';
import 'package:kavesys_app/screens/roles_screen.dart';
import 'package:kavesys_app/services/app_state_service.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateService>(
      builder: (context, appState, child) {
        final user = appState.user;
        final (widgetOptions, widgetTitles, navBarItems) = _buildNavItems(user?.role);

        // Ensure selectedIndex is valid
        if (_selectedIndex >= navBarItems.length) {
          _selectedIndex = 0;
        }

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const KaveLogo(width: 24, height: 24),
                const SizedBox(width: 8),
                Text(widgetTitles.elementAt(_selectedIndex)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => Provider.of<AppStateService>(context, listen: false).logout(),
              ),
            ],
          ),
          body: Center(
            child: widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: navBarItems,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
    );
  }

  (List<Widget>, List<String>, List<BottomNavigationBarItem>) _buildNavItems(UserRole? userRole) {
    final options = <Widget>[
      DashboardScreen(),
      InventoryScreen(),
      ReportsScreen(),
      ProfileScreen(),
    ];
    final titles = <String>[
      'Dashboard',
      'Inventario',
      'Reportes',
      'Mi Perfil',
    ];
    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
      const BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventario'),
      const BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reportes'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
    ];

    if (userRole == UserRole.administrador || userRole == UserRole.almacenista) {
      options.add(GestionScreen());
      titles.add('Gestión');
      items.add(const BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Gestión'));
    }

    if (userRole == UserRole.administrador) {
      options.add(RolesScreen());
      titles.add('Roles');
      items.add(const BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Roles'));
    }

    options.add(ContactScreen());
    titles.add('Contacto');
    items.add(const BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: 'Contacto'));

    return (options, titles, items);
  }
}
