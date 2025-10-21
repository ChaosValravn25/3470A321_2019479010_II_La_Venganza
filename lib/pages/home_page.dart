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
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'backup') {
                await config.backupToFile();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("💾 Respaldo guardado exitosamente")),
                );
              } else if (value == 'restore') {
                await config.restoreFromFile();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("🔁 Configuración restaurada")),
                );
              } else {
                Navigator.pushNamed(context, value);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: '/config', child: Text('Configuración')),
              const PopupMenuItem(value: '/pixelArt', child: Text('Pixel Art')),
              const PopupMenuItem(value: '/listArt', child: Text('Lista de Arte')),
              const PopupMenuItem(value: '/listCreation', child: Text('Creaciones')),
              const PopupMenuItem(value: '/about', child: Text('Acerca de')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'backup', child: Text('💾 Crear respaldo')),
              const PopupMenuItem(value: 'restore', child: Text('🔁 Restaurar respaldo')),
            ],
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Laboratorio 7 - Persistencia extendida\n(Rutas y archivos locales)",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: config.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 30),
              Text(
                "Color activo: ${config.mainColorString}",
                style: TextStyle(fontSize: 16, color: config.mainColor),
              ),
              const SizedBox(height: 40),
              _buildButton(context, "🎨 Pixel Art", '/pixelArt', Colors.teal),
              _buildButton(context, "⚙️ Configuración", '/config', Colors.orange),
              _buildButton(context, "📋 Lista de Arte", '/listArt', Colors.indigo),
              _buildButton(context, "🧱 Creaciones", '/listCreation', Colors.blueGrey),
              _buildButton(context, "ℹ️ Acerca de", '/about', Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, String route, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: 250,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () {
            logger.i("Navegando a $route");
            Navigator.pushNamed(context, route);
          },
          child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
