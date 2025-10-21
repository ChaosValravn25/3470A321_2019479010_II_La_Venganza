import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/configuration_data.dart';


class ListCreationScreen extends StatelessWidget {
  const ListCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigurationData>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Creaciones"),
        backgroundColor: config.mainColor,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 8,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: config.mainColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "Creación ${index + 1}",
                style: TextStyle(
                  color: config.mainColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
