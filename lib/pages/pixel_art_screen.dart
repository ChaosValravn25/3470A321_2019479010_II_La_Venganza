import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../providers/configuration_data.dart';

var logger = Logger();

class PixelArtScreen extends StatefulWidget {
  const PixelArtScreen({super.key});

  @override
  State<PixelArtScreen> createState() => _PixelArtScreenState();
}

class _PixelArtScreenState extends State<PixelArtScreen> {
  late List<List<Color>> grid;

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
    logger.d("reassemble ejecutado");
  }

  @override
  void initState() {
    super.initState();
    final gridSize = context.read<ConfigurationData>().gridSize;
    grid = List.generate(gridSize, (_) => List.filled(gridSize, Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigurationData>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: config.mainColor,
        title: const Text("Pixel Art"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: config.gridSize),
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
                    },
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      color: grid[x][y],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  grid = List.generate(config.gridSize,
                      (_) => List.filled(config.gridSize, Colors.white));
                });
              },
              child: const Text("Limpiar grilla"),
            ),
          ],
        ),
      ),
    );
  }
}