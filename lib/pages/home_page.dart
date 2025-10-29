import 'dart:io';
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
        title: Text(title),
        backgroundColor: config.mainColor,
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
           } else if (value == 'share') {
          await config.shareBackupFile(); // 👈 esta es la línea clave
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("📤 Respaldo compartido")),
          );
            } else {
              Navigator.pushNamed(context, value);
            }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '/config', child: Text('Configuración')),
              const PopupMenuItem(value: '/pixelArt', child: Text('Pixel Art')),
              const PopupMenuItem(value: '/listArt', child: Text('Lista de Arte')),
              const PopupMenuItem(value: '/listCreation', child: Text('Creaciones')),
              const PopupMenuItem(value: '/about', child: Text('Acerca de')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'backup', child: Text('💾 Crear respaldo')),
              const PopupMenuItem(value: 'restore', child: Text('🔁 Restaurar respaldo')),
              const PopupMenuItem(value: 'shareBackup', child: Text('📤 Compartir respaldo')),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Laboratorio 8 - Interacción con otras aplicaciones",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: config.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            if (config.lastImagePath != null)
              Image.file(File(config.lastImagePath!), height: 180)
            else
              const Text("No hay creaciones recientes"),
            const SizedBox(height: 30),
            _buildButton(context, "🎨 Pixel Art", '/pixelArt', Colors.teal),
            _buildButton(context, "⚙️ Configuración", '/config', Colors.orange),
            _buildButton(context, "📋 Lista de Arte", '/listArt', Colors.indigo),
            _buildButton(context, "🧱 Creaciones", '/listCreation', Colors.blueGrey),
            _buildButton(context, "ℹ️ Acerca de", '/about', Colors.green),
          ],
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
          ),
          onPressed: () {
            Navigator.pushNamed(context, route);
            logger.i("Navegando a $route");
          },
          child: Text(text),
        ),
      ),
    );
  }
}
