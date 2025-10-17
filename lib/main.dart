import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/configuration_data.dart';
import 'services/shared_preferences_service.dart';
import 'pages/home_page.dart';
import 'pages/configuration_screen.dart';
import 'pages/pixel_art_screen.dart';
import 'pages/list_art.dart';
import 'pages/list_creation.dart';
import 'pages/about.dart';
import 'package:logger/logger.dart';

var logger = Logger();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final prefsService = SharedPreferencesService();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ConfigurationData(prefsService),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     final config = Provider.of<ConfigurationData>(context);
    logger.i("Construyendo MyApp"); //  Log de MyApp
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 6 Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: config.mainColor),
        fontFamily: 'Jacquard12', //  incluyes fuente personalizada
        useMaterial3: true,
      ),
     initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(title: 'Inicio - Lab 6'),
        '/config': (context) => const ConfigurationScreen(),
        '/about': (context) => const AboutScreen(),
        '/pixelArt': (context) => const PixelArtScreen(),
        '/listArt': (context) => const ListArtScreen(),
        '/listCreation': (context) => const ListCreationScreen(),}
    );
  }
}
