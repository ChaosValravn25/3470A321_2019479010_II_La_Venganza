import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'providers/configuration_data.dart';
import 'pages/home_page.dart';
import 'pages/pixel_art_screen.dart';
import 'pages/configuration_screen.dart';
import 'pages/about.dart';
import 'pages/list_art.dart';
import 'pages/list_creation.dart';

var logger = Logger();

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ConfigurationData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i("Construyendo MyApp"); //  Log de MyApp
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 5 Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        fontFamily: 'Jacquard12', //  incluyes fuente personalizada
        useMaterial3: true,
      ),
     initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(title: 'Inicio - Lab 5'),
        '/config': (context) => const ConfigurationScreen(),
        '/about': (context) => const AboutScreen(),
        '/pixelArt': (context) => const PixelArtScreen(),
        '/listArt': (context) => const ListArtScreen(),
        '/listCreation': (context) => const ListCreationScreen(),}
    );
  }
}
