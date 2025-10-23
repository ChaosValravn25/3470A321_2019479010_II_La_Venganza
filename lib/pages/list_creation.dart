import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../providers/configuration_data.dart';

class ListCreationScreen extends StatefulWidget {
  const ListCreationScreen({super.key});

  @override
  _ListCreationScreenState createState() => _ListCreationScreenState();
}

class _ListCreationScreenState extends State<ListCreationScreen> {
  late Future<List<File>> _imageFiles;

  @override
  void initState() {
    super.initState();
    _loadImages(); // Cargar imágenes al iniciar la pantalla
  }

  /// 🔹 Carga los archivos .png desde el directorio local
  Future<void> _loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory
        .listSync()
        .where((file) => file.path.endsWith('.png'))
        .cast<File>()
        .toList();

    setState(() {
      _imageFiles = Future.value(files);
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigurationData>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("🧱 Mis Creaciones"),
        backgroundColor: config.mainColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Actualizar lista",
            onPressed: _loadImages, // Recargar la lista de imágenes
          ),
        ],
      ),
      body: FutureBuilder<List<File>>(
        future: _imageFiles,
        builder: (context, snapshot) {
          // 🕐 Estado de carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ⚠️ Error al cargar
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar las imágenes: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          // 📂 Sin archivos guardados
          final files = snapshot.data ?? [];
          if (files.isEmpty) {
            return Center(
              child: Text(
                "No se han guardado creaciones aún 🖼️",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            );
          }

          // 🖼️ Mostrar imágenes guardadas
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: files.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Dos imágenes por fila
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final imageFile = files[index];

              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: config.mainColor, width: 2),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        color: Colors.black45,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Creación ${index + 1}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
