
enum UserRole {
  cliente,
  administrador,
  produccion,
  mantenimiento,
  oficina,
  almacenista,
  vendedor,
  proveedor,
}

class User {
  final int id;
  final String name;
  final UserRole role;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.cliente,
      ),
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role.toString().split('.').last,
      'email': email,
    };
  }
}
