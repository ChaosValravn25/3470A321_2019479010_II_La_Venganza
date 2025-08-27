import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
void main() {
  var logger = Logger();
  logger.d("Logger iniciado correctamente");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 2 Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), // Cambia el color principal
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '2019479010'), // Cambiar título a matrícula
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Color _currentColor = Colors.blue; // Color inicial

  // Funciones del contador
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
// Función para disminuir el contador
  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }
// Función para resetear el contador
  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  // Función para cambiar color
  void _changeColor() {
    setState(() {
      _currentColor =
          (_currentColor == Colors.blue) ? Colors.red : Colors.blue;
    });
  }

  // ✅ Refactor: botones del footer en un método aparte
  List<Widget> _buildFooterButtons() {
    return [
      IconButton(
        icon: const Icon(Icons.remove),
        onPressed: _decrementCounter,
        tooltip: "Restar",
      ),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: _incrementCounter,
        tooltip: "Sumar",
      ),
      IconButton(
        icon: const Icon(Icons.refresh),
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
// Build method
  @override
  Widget build(BuildContext context) {
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
              "Pixel Art sobre una grilla personalizable", // Texto en español
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text(
              '$_counter',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: _currentColor,
              ),
            ),
          ],
        ),
      ),
      // Botones persistentes en la parte inferior
      persistentFooterButtons: _buildFooterButtons(),
      // FAB (opcional, lo puedes eliminar si el profe pide mover todo al footer)
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Incrementar',
        child: const Icon(Icons.brush), // Ícono de arte
      ),
    );
  }
}