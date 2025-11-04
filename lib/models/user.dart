
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
}
