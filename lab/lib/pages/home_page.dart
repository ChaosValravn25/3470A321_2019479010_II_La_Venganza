import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'list_art.dart';
import 'list_creation.dart';
import 'about.dart';

var logger = Logger();

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  Color _currentColor = Colors.green;

  // Funciones del contador
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _changeColor() {
    setState(() {
      _currentColor =
          (_currentColor == Colors.blue) ? Colors.orange : Colors.blue;
    });
  }

  // Botones del footer
  List<Widget> _buildFooterButtons() {
    return [
      IconButton(
        icon: SvgPicture.asset('assets/icons/pawn.svg', width: 24, height: 24),
        onPressed: _decrementCounter,
        tooltip: "Restar",
      ),
      IconButton(
        icon: SvgPicture.asset('assets/icons/raven.svg', width: 24, height: 24),
        onPressed: _incrementCounter,
        tooltip: "Sumar",
      ),
      IconButton(
        icon: SvgPicture.asset('assets/icons/dog.svg', width: 24, height: 24),
        onPressed: _resetCounter,
        tooltip: "Restaurar",
      ),
      IconButton(
        icon: const Icon(Icons.color_lens),
        onPressed: _changeColor,
        tooltip: "Cambiar color",
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    logger.w("Widget HomePage inicializado");
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Construyendo HomePage_lab_4");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _currentColor,
        title: Text(widget.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'list') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListArtScreen()),
                );
              } else if (value == 'about') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'list', child: Text('Lista')),
              PopupMenuItem(value: 'about', child: Text('Sobre')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  "Pixel Art sobre una grilla personalizable",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  "Crea, guarda y comparte tus diseños en pixeles.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),

                // Contador
                Center(
                  child: Text(
                    '$_counter',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: _currentColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Imágenes
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Image.asset('assets/images/Hot-Pepper.webp',
                          width: 80, height: 80),
                      const SizedBox(width: 10),
                      Image.asset('assets/images/Pizza.webp',
                          width: 80, height: 80),
                      const SizedBox(width: 10),
                      Image.asset('assets/images/Watermelon.webp',
                          width: 80, height: 80),
                    ],
                  ),
                ),

                const Spacer(),

                // Botones Crear y Compartir
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("Crear"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ListArtScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.share),
                        label: const Text("Compartir"),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Funcionalidad compartir próxima…')),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Acceso a Mis Creaciones
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    icon: const Icon(Icons.collections),
                    label: const Text('Mis Creaciones'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ListCreationScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: _buildFooterButtons(),
    );
  }
}
