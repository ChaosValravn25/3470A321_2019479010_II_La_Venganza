import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          (_currentColor == Colors.blue) ? Colors.red : Colors.blue;
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
    logger.w("Widget HomePage inicializado"); // Log de MyHomePage
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Construyendo HomePage_lab_3"); // Log en build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _currentColor,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Pixel Art sobre una grilla personalizable",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 35),
            Text(
              '$_counter',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: _currentColor,
              ),
            ),
            const SizedBox(height: 30),
            // ✅ Imágenes como pide Lab 3
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/Hot-Pepper.webp', width: 80, height: 80),
                  const SizedBox(width: 10),
                  Image.asset('assets/images/Pizza.webp', width: 80, height: 80),
                  const SizedBox(width: 10),
                  Image.asset('assets/images/Watermelon.webp', width: 80, height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: _buildFooterButtons(),
    );
  }
}
