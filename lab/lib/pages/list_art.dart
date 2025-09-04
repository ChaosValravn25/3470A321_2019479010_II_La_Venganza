import 'package:flutter/material.dart';

class ListArtScreen extends StatelessWidget {
  const ListArtScreen({super.key});

  // Lista local de artes disponibles (puedes cambiar los nombres)
  final List<String> arts = const [
    'Gato 8x8', 'Creeper', 'Space Invader', 'Corazón', 'Hongo Mario'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pixel Art List')),
      body: ListView.builder(
        itemCount: arts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.grid_on), // ícono para lista de artes
            title: Text(arts[index]),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seleccionaste: ${arts[index]}')),
              );
            },
          );
        },
      ),
    );
  }
}
