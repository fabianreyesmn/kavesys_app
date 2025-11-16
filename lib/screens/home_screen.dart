import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;

class HomeScreen extends StatelessWidget {
  final VoidCallback onProductsNavigator;
  final VoidCallback onLoginNavigator;

  const HomeScreen({Key? key, required this.onProductsNavigator, required this.onLoginNavigator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plásticos KAVE'),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.login),
            label: Text('Login'),
            onPressed: onLoginNavigator,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel de Banners
            carousel_slider.CarouselSlider(
              options: carousel_slider.CarouselOptions(
                height: 250.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: [
                _buildCarouselItem(context, 'Materiales 100% vírgenes', 'Garantizamos resistencia, precisión y acabado profesional.', Icons.shield),
                _buildCarouselItem(context, 'Fabricación Mexicana', 'Orgullosamente una empresa 100% mexicana con visión global.', Icons.flag),
                _buildCarouselItem(context, 'Comprometidos con la calidad', 'Tu satisfacción es nuestra prioridad en cada producto.', Icons.thumb_up),
              ],
            ),
            SizedBox(height: 32),

            // Sección de Bienvenida
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    'Bienvenido a Plásticos KAVE',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Icon(Icons.business, size: 100, color: Colors.blue.shade600), // Placeholder for the logo
                  SizedBox(height: 16),
                  Text(
                    'Plásticos KAVE es una empresa 100% mexicana con más de 30 años de experiencia en el ramo de inyección de plástico. nuestros productos principales son las conexiones para duraducto o conexiones de inserción, regatones o tapones para sillas, artículos para ferretería entre otros, los cuales son fabricadas con materiales virgen lo cual garantiza una gran calidad en cualquiera de nuestros productos.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: onProductsNavigator,
                    child: Text('Explora nuestros productos'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Divider(height: 1, color: Colors.grey.shade300, indent: 16, endIndent: 16),
            SizedBox(height: 32),

            // Sección de Características
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildFeatureCard('Calidad Garantizada', 'Utilizamos materiales vírgenes para asegurar la durabilidad y resistencia de nuestros productos.', Icons.verified_user),
                  SizedBox(height: 16),
                  _buildFeatureCard('30+ Años de Experiencia', 'Décadas de liderazgo en la industria de inyección de plástico en México.', Icons.history),
                  SizedBox(height: 16),
                  _buildFeatureCard('Amplio Catálogo', 'Desde conexiones para duraducto hasta artículos de ferretería especializados.', Icons.inventory_2),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, String title, String subtitle, IconData icon) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.blue.shade700,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.white),
          SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              subtitle,
              style: TextStyle(color: Colors.white70, fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blue.shade600),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}