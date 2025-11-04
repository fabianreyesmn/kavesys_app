import 'package:flutter/material.dart';
import 'package:kavesys_app/components/icons.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onClientView;
  final bool Function(String, String) onLogin;

  const LoginScreen({
    Key? key,
    required this.onClientView,
    required this.onLogin,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String? _error;

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final success = widget.onLogin(_email, _password);
      if (!success) {
        setState(() {
          _error = 'Credenciales incorrectas. Intente de nuevo.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const KaveLogo(width: 96, height: 96),
                const SizedBox(height: 8),
                const Text(
                  'Plásticos KAVE',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1f2937)),
                ),
                const Text(
                  'KAVE Sys',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Gestión de Inventario',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Acceso de Empleados',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Correo Electrónico',
                            hintText: 'ej: admin@kave.com',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) => _email = value!,
                          validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingrese su correo' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            hintText: '************',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          onSaved: (value) => _password = value!,
                          validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingrese su contraseña' : null,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Hint: usa 'password'",
                          style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red[700]),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Iniciar Sesión'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('o'),
                TextButton(
                  onPressed: widget.onClientView,
                  child: const Text('Ver catálogo de productos como cliente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}