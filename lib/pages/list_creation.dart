import 'package:flutter/material.dart';

class ListCreationScreen extends StatelessWidget {
  const ListCreationScreen({super.key});

  // Lista local de creaciones del usuario
  final List<String> creations = const [
    'Mi Creeper', 'Mario 8x8', 'Logo U', 'Corazón arcoíris'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Creaciones')),
      body: ListView.separated(
        itemCount: creations.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.brush), // ícono para “creaciones”
            title: Text(creations[index]),
            trailing: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Compartir: ${creations[index]}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
