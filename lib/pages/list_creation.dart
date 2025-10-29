import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import '../providers/configuration_data.dart';
import '../model/pixel_art.dart';
import '../services/pixel_art_repository.dart';

class ListCreationScreen extends StatefulWidget {
  const ListCreationScreen({super.key});

  @override
  _ListCreationScreenState createState() => _ListCreationScreenState();
}

class _ListCreationScreenState extends State<ListCreationScreen> {
  late Future<List<File>> _imageFiles;
  late Future<List<PixelArt>> _pixelArts;

  @override
  void initState() {
    super.initState();
    _loadAllData(); // Cargar tanto imágenes como PixelArts guardados
  }

  /// 🔹 Carga imágenes y PixelArts desde el almacenamiento local
  Future<void> _loadAllData() async {
    final directory = await getApplicationDocumentsDirectory();

    // Archivos .png del laboratorio anterior
    final imageList = directory
        .listSync()
        .where((file) => file.path.endsWith('.png'))
        .cast<File>()
        .toList();

    // Archivos .json del repositorio PixelArt
    final repo = PixelArtRepository();
    final pixelArts = await repo.listAll();

    setState(() {
      _imageFiles = Future.value(imageList);
      _pixelArts = Future.value(pixelArts);
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
            onPressed: _loadAllData, // Recargar listas
          ),
        ],
      ),
      body: FutureBuilder<List<File>>(
        future: _imageFiles,
        builder: (context, imageSnapshot) {
          return FutureBuilder<List<PixelArt>>(
            future: _pixelArts,
            builder: (context, artSnapshot) {
              if (imageSnapshot.connectionState == ConnectionState.waiting ||
                  artSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (imageSnapshot.hasError || artSnapshot.hasError) {
                return Center(
                  child: Text(
                    'Error al cargar creaciones: ${imageSnapshot.error ?? artSnapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final images = imageSnapshot.data ?? [];
              final arts = artSnapshot.data ?? [];

              // 📂 Si no hay nada guardado
              if (images.isEmpty && arts.isEmpty) {
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

              // 🖼️ Mostrar ambas listas (primero JSONs, luego imágenes)
              return ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  if (arts.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🎨 Pixel Arts guardados",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: config.mainColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...arts.map((art) => Card(
                              elevation: 2,
                              child: ListTile(
                                leading: const Icon(Icons.grid_on),
                                title: Text(art.title),
                                subtitle: Text(
                                    "Editado: ${art.lastModifiedAt.toLocal()}"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    final repo = PixelArtRepository();
                                    await repo.delete(art.id);
                                    _loadAllData();
                                  },
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, '/pixelArt',
                                      arguments: art);
                                },
                              ),
                            )),
                        const SizedBox(height: 20),
                      ],
                    ),
                  if (images.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🖼️ Imágenes exportadas (.png)",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: config.mainColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: images.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            final imageFile = images[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: config.mainColor, width: 2),
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
                        ),
                      ],
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}