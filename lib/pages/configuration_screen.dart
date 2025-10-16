import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/configuration_data.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigurationData>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: config.mainColor,
        title: const Text("Configuración"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Selecciona el color principal:",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              children: [
                for (var color in [
                  Colors.green,
                  Colors.red,
                  Colors.blue,
                  Colors.purple,
                  Colors.orange
                ])
                  GestureDetector(
                    onTap: () => config.setMainColor(color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(
                            color: config.mainColor == color
                                ? Colors.black
                                : Colors.grey,
                            width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 30),
            Text("Tamaño de la grilla: ${config.gridSize}x${config.gridSize}"),
            Slider(
              value: config.gridSize.toDouble(),
              min: 4,
              max: 20,
              divisions: 16,
              label: config.gridSize.toString(),
              onChanged: (value) => config.setGridSize(value.toInt()),
            ),
          ],
        ),
      ),
    );
  }
}