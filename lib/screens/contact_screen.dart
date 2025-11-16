import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _message = '';
  bool _isSending = false;

  final String _backendUrl = 'http://10.13.202.217:3000/enviar-contacto';
  final String _mapUrl = 'https://www.google.com/maps?q=Av.+H%C3%A9roe+de+Nacozari+Nte.+2406,+Fraccionamiento+Industrial,+20140+Aguascalientes,+Ags.,+Mexico';

  Future<void> _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      try {
        final response = await http.post(
          Uri.parse(_backendUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'nombre': _name,
            'email': _email,
            'mensaje': _message,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('¡Mensaje enviado! Gracias por contactarnos.')),
          );
          _formKey.currentState!.reset();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al enviar el mensaje. Inténtalo de nuevo.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión: $e')),
        );
      }

      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _launchMap() async {
    if (await launchUrl(Uri.parse(_mapUrl))) {
      // Launched successfully
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el mapa.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacto'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Envíanos un mensaje',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue.shade800),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? 'Por favor, ingresa tu nombre' : null,
                    onSaved: (value) => _name = value!,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => (value == null || !value.contains('@')) ? 'Ingresa un correo válido' : null,
                    onSaved: (value) => _email = value!,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Mensaje',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.message),
                    ),
                    maxLines: 4,
                    validator: (value) => (value == null || value.isEmpty) ? 'Por favor, escribe tu mensaje' : null,
                    onSaved: (value) => _message = value!,
                  ),
                  SizedBox(height: 24),
                  _isSending
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _sendMessage,
                          child: Text('Enviar Mensaje'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Divider(),
            SizedBox(height: 16),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue.shade700, size: 40),
                title: Text('Nuestra Ubicación'),
                subtitle: Text('Av. Héroe de Nacozari Nte. 2406, Aguascalientes, Ags.'),
                trailing: Icon(Icons.chevron_right),
                onTap: _launchMap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}