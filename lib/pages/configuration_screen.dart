// lib/pages/configuration_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/configuration_data.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigurationData>(context);

    if (config.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Configuración')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(backgroundColor: config.mainColor, title: const Text('Configuración')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Tamaño de la grilla: ${config.gridSize}'),
            Slider(
              value: config.gridSize.toDouble(),
              min: 4,
              max: 24,
              divisions: 20,
              label: '${config.gridSize}',
              onChanged: (value) => config.setGridSize(value.toInt()),
            ),
            const SizedBox(height: 20),
            Text('Color principal:'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                _colorChoice(context, Colors.green),
                _colorChoice(context, Colors.blue),
                _colorChoice(context, Colors.red),
                _colorChoice(context, Colors.purple),
                _colorChoice(context, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorChoice(BuildContext context, Color color) {
    final config = Provider.of<ConfigurationData>(context, listen: false);
    return GestureDetector(
      onTap: () => config.setMainColor(color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black12),
        ),
      ),
    );
  }
}
