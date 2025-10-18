import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../providers/configuration_data.dart';

// Inicializamos el logger para registrar los eventos del ciclo de vida
var logger = Logger();

/// Pantalla principal para crear dibujos tipo Pixel Art.
/// Esta versión se encuentra modificada para el Laboratorio N°6:
/// ahora integra datos persistentes del Provider `ConfigurationData`,
/// que obtiene su información desde SharedPreferences.
class PixelArtScreen extends StatefulWidget {
  const PixelArtScreen({super.key});

  @override
  State<PixelArtScreen> createState() => _PixelArtScreenState();
}

class _PixelArtScreenState extends State<PixelArtScreen> {
  late List<List<Color>> grid;
  bool initialized = false; // controla si la grilla ya fue generada

  // ----------------------------------------------------------
  // CICLO DE VIDA DEL STATEFUL WIDGET
  // ----------------------------------------------------------
  @override
  void initState() {
    super.initState();
    logger.i("initState ejecutado → preparando grilla inicial (sin datos aún)");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    logger.i("didChangeDependencies ejecutado → dependencias listas");
  }

  @override
  void didUpdateWidget(covariant PixelArtScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    logger.i("didUpdateWidget ejecutado → se actualizó el widget");
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    logger.i("setState ejecutado → el estado cambió");
  }

  @override
  void deactivate() {
    super.deactivate();
    logger.w("deactivate ejecutado → widget fuera del árbol temporalmente");
  }

  @override
  void dispose() {
    super.dispose();
    logger.w("dispose ejecutado → widget destruido correctamente");
  }

  @override
  void reassemble() {
    super.reassemble();
    logger.d("reassemble ejecutado → hot reload detectado");
  }

  // ----------------------------------------------------------
  // CONSTRUCCIÓN DE LA INTERFAZ
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigurationData>(context);

    // 1️⃣ Mientras se cargan los datos persistidos (SharedPreferences)
    if (config.isLoading) {
      logger.i("Cargando configuración persistida...");
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[400],
          title: const Text("Pixel Art"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 2️⃣ Cuando la configuración ya está lista, inicializamos la grilla una sola vez
    if (!initialized) {
      grid = List.generate(
        config.gridSize,
        (_) => List.filled(config.gridSize, Colors.white),
      );
      initialized = true;
      logger.i("Grilla inicializada con tamaño ${config.gridSize}x${config.gridSize}");
    }

    // 3️⃣ Construcción principal del Scaffold
    return Scaffold(
      appBar: AppBar(
        backgroundColor: config.mainColor,
        title: const Text("Pixel Art"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Limpiar grilla',
            onPressed: () {
              setState(() {
                grid = List.generate(
                  config.gridSize,
                  (_) => List.filled(config.gridSize, Colors.white),
                );
              });
              logger.i("Grilla reiniciada manualmente");
            },
          ),
        ],
      ),

      // 4️⃣ Cuerpo principal
      body: Center(
        child: Column(
          children: [
            // Grilla dinámica generada con base en la configuración persistente
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: config.gridSize,
                ),
                itemCount: config.gridSize * config.gridSize,
                itemBuilder: (context, index) {
                  final x = index ~/ config.gridSize;
                  final y = index % config.gridSize;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        grid[x][y] = grid[x][y] == Colors.white
                            ? config.mainColor
                            : Colors.white;
                      });
                      logger.d("Celda [$x][$y] alternada → ${grid[x][y]}");
                    },
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      color: grid[x][y],
                    ),
                  );
                },
              ),
            ),

            // Botón para limpiar grilla (reinicio visual)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  grid = List.generate(
                    config.gridSize,
                    (_) => List.filled(config.gridSize, Colors.white),
                  );
                });
                logger.i("🧹 Grilla limpiada por el usuario");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: config.mainColor,
                foregroundColor: Colors.white,
              ),
              child: const Text("🧹 Limpiar grilla"),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
