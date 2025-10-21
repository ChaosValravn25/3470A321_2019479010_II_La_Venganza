import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/configuration_data.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ListArtScreen extends StatelessWidget {
  const ListArtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigurationData>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Arte"),
        backgroundColor: config.mainColor,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.image),
            title: Text("Pixel Art #$index"),
            subtitle: const Text("Creación simple de ejemplo"),
            onTap: () {
              logger.i("Abriendo Pixel Art #$index");
            },
          );
        },
      ),
    );
  }
}
