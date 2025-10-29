import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import '../providers/configuration_data.dart';


var logger = Logger();

class PixelArtScreen extends StatefulWidget {
  const PixelArtScreen({super.key});

  @override
  State<PixelArtScreen> createState() => _PixelArtScreenState();
}

class _PixelArtScreenState extends State<PixelArtScreen> {
  late List<List<Color>> grid;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    logger.i("initState ejecutado - preparando grilla inicial");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    logger.i("didChangeDependencies ejecutado");
  }

  @override
  void didUpdateWidget(covariant PixelArtScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    logger.i("didUpdateWidget ejecutado");
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    logger.i("setState ejecutado");
  }

  @override
  void deactivate() {
    super.deactivate();
    logger.w("deactivate ejecutado");
  }

  @override
  void dispose() {
    super.dispose();
    logger.w("dispose ejecutado");
  }

  @override
  void reassemble() {
    super.reassemble();
    logger.d("reassemble ejecutado (Hot Reload)");
  }

  Future<String> _savePixelArt() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, grid.length * 20.0, grid.length * 20.0));
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[row].length; col++) {
        final paint = Paint()..color = grid[row][col];
        canvas.drawRect(Rect.fromLTWH(col * 20.0, row * 20.0, 20.0, 20.0), paint);
      }
    }
    final picture = recorder.endRecording();
    final image = await picture.toImage(grid.length * 20, grid.length * 20);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final imageBytes = byteData!.buffer.asUint8List();
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/pixel_art_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
    logger.d("Pixel art saved to: $filePath");
    if (mounted) {
      final config = Provider.of<ConfigurationData>(context, listen: false);
      config.addCreation(filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pixel art saved to: $filePath')),
      );
    }
    return filePath;
  }

  Future<void> _sharePixelArt() async {
    if (mounted && grid.isNotEmpty) {
      final filePath = await _savePixelArt();
      final xFile = XFile(filePath, mimeType: 'image/png');
      await Share.shareXFiles([xFile], text: '¡Mira mi increíble pixel art creado el ${DateTime.now()} a las 01:09 AM -03!');
      logger.i("Imagen compartida desde: $filePath");
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigurationData>(context);

    if (config.isLoading) {
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

    if (!initialized) {
      grid = List.generate(
        config.gridSize,
        (_) => List.filled(config.gridSize, Colors.white),
      );
      initialized = true;
      logger.i("Grilla inicializada con tamaño ${config.gridSize}x${config.gridSize}");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: config.mainColor,
        title: const Text("Pixel Art"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            tooltip: 'Guardar imagen',
            onPressed: _savePixelArt,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Compartir imagen',
            onPressed: _sharePixelArt,
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Restaurar configuración',
            onPressed: () async {
              await config.restoreFromFile();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Configuración restaurada desde archivo"),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
              logger.i("Configuración restaurada desde archivo local");
            },
          ),
        ],
      ),
      body: Center(
  child: Container(
    decoration: config.backgroundImagePath != null
        ? BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(config.backgroundImagePath!)),
              fit: BoxFit.cover,
              opacity: config.backgroundOpacity,
            ),
          )
        : null,
    child: Column(
      children: [
        Expanded(
          child: GridView.builder(
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
                  logger.d("Célula ($x, $y) cambiada a ${grid[x][y]}");
                },
                child: Container(
                  margin: const EdgeInsets.all(1),
                  color: grid[x][y],
                ),
              );
            },
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              grid = List.generate(
                config.gridSize,
                (_) => List.filled(config.gridSize, Colors.white),
              );
            });
            logger.i("Grilla reiniciada por el usuario");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: config.mainColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          ),
          icon: const Icon(Icons.cleaning_services_outlined),
          label: const Text("Limpiar grilla"),
        ),
        const SizedBox(height: 20),
      ],
    ),
  ),
),
    );
  }
}