import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'pages/home_page.dart'; //Importamos la nueva página

var logger = Logger();

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i("Construyendo MyApp"); //  Log de MyApp
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 3 Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        fontFamily: 'Jacquard12', //  incluyes fuente personalizada
        useMaterial3: true,
      ),
      home: const HomePage(title: '2019479010'), //Ahora usamos HomePage desde pages
    );
  }
}
