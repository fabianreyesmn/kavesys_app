
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kavesys_app/services/app_state_service.dart';
import 'package:kavesys_app/models/user.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({Key? key}) : super(key: key);

  @override
  _RolesScreenState createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  String _searchText = '';
  UserRole? _selectedRoleFilter;

  void _updateUserRole(BuildContext context, User user, UserRole newRole) {
    final appState = Provider.of<AppStateService>(context, listen: false);
    final updatedUser = User(id: user.id, name: user.name, email: user.email, role: newRole);
    
    appState.updateUser(updatedUser).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rol de ${user.name} actualizado a ${newRole.toString().split('.').last}')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el rol: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateService>(
      builder: (context, appState, child) {
        final filteredUsers = appState.users.where((user) {
          final nameMatches = user.name.toLowerCase().contains(_searchText.toLowerCase());
          final roleMatches = _selectedRoleFilter == null || user.role == _selectedRoleFilter;
          return nameMatches && roleMatches;
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
                        labelText: 'Buscar por nombre',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<UserRole?>(
                      isExpanded: true,
                      value: _selectedRoleFilter,
                      hint: const Text('Filtrar por rol'),
                      onChanged: (UserRole? newValue) {
                        setState(() {
                          _selectedRoleFilter = newValue;
                        });
                      },
                      items: [
                        const DropdownMenuItem(child: Text('Todos los roles'), value: null),
                        ...UserRole.values.map((role) {
                          return DropdownMenuItem(
                            child: Text(role.toString().split('.').last),
                            value: role,
                          );
                        }).toList()
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      trailing: DropdownButton<UserRole>(
                        value: user.role,
                        onChanged: (UserRole? newValue) {
                          if (newValue != null) {
                            _updateUserRole(context, user, newValue);
                          }
                        },
                        items: UserRole.values.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role.toString().split('.').last),
                          );
                        }).toList(),
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
