import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

// Servicios
import 'services/shared_preferences_service.dart';
import 'services/file_storage_service.dart';

// Providers
import 'providers/configuration_data.dart';

// Páginas
import 'pages/home_page.dart';
import 'pages/configuration_screen.dart';
import 'pages/about.dart';
import 'pages/pixel_art_screen.dart';
import 'pages/list_art.dart';
import 'pages/list_creation.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de servicios persistentes
  final prefsService = SharedPreferencesService();
  final fileService = FileStorageService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ConfigurationData(prefsService, fileService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigurationData>(context);
    return MaterialApp(
      title: 'Laboratorio 7 - Persistencia extendida',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: config.mainColor),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(title: '2019479010'),
        '/config': (context) => const ConfigurationScreen(),
        '/pixelArt': (context) => const PixelArtScreen(),
        '/listArt': (context) => const ListArtScreen(),
        '/listCreation': (context) => const ListCreationScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}
