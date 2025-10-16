import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../providers/configuration_data.dart';
final logger = Logger();

class HomePage extends StatelessWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigurationData>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: config.mainColor,
        title: Text(title),

        // 🔸 Menú desplegable (PopupMenuButton)
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'config') {
                Navigator.pushNamed(context, '/config');
              } else if (value == 'about') {
                Navigator.pushNamed(context, '/about');
              } else if (value == 'pixelArt') {
                Navigator.pushNamed(context, '/pixelArt');
              } else if (value == 'listArt') {
                Navigator.pushNamed(context, '/listArt');
              } else if (value == 'listCreation') {
                Navigator.pushNamed(context, '/listCreation');
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'config',
                child: Text('Configuración'),
              ),
              const PopupMenuItem(
                value: 'pixelArt',
                child: Text('Pixel Art'),
              ),
              const PopupMenuItem(
                value: 'listArt',
                child: Text('Lista de Arte'),
              ),
              const PopupMenuItem(
                value: 'listCreation',
                child: Text('Creaciones'),
              ),
              const PopupMenuItem(
                value: 'about',
                child: Text('Acerca de'),
              ),
            ],
          ),
        ],
      ),

      // 🔸 Cuerpo principal
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Laboratorio 5 - Estados del Widget y Data en la App",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: config.mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Color activo: ${config.mainColorString}",
                  style: TextStyle(fontSize: 16, color: config.mainColor),
                ),
                const SizedBox(height: 40),

                // 🔹 Botones para navegar entre pantallas
                _buildNavButton(
                  context,
                  label: "🎨 Ir a Pixel Art",
                  color: Colors.teal,
                  route: '/pixelArt',
                ),
                _buildNavButton(
                  context,
                  label: "⚙️ Configuración",
                  color: Colors.deepOrange,
                  route: '/config',
                ),
                _buildNavButton(
                  context,
                  label: "🧩 Lista de Arte",
                  color: Colors.indigo,
                  route: '/listArt',
                ),
                _buildNavButton(
                  context,
                  label: "🧱 Creaciones",
                  color: Colors.blueGrey,
                  route: '/listCreation',
                ),
                _buildNavButton(
                  context,
                  label: "ℹ️ Acerca de",
                  color: Colors.green,
                  route: '/about',
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  "Manejo de estados con Provider\nLogger activo para monitorear ciclo de vida.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔸 Widget reutilizable para botones de navegación
  Widget _buildNavButton(BuildContext context,
      {required String label, required Color color, required String route}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            logger.i("Navegando a $route");
            Navigator.pushNamed(context, route);
          },
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}