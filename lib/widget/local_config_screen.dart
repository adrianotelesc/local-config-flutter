import 'package:flutter/material.dart';

class LocalConfigScreen extends StatelessWidget {
  final List<MapEntry<String, String>> configs;

  const LocalConfigScreen({super.key, required this.configs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Config')),
      body: ListView.builder(
        itemCount: configs.length,
        itemBuilder: (context, index) {
          final entry = configs[index];

          String type = 'String';
          if (bool.tryParse(entry.value) != null) {
            type = 'bool';
          } else if (int.tryParse(entry.value) != null) {
            type = 'int';
          } else if (double.tryParse(entry.value) != null) {
            type = 'double';
          }

          return InkWell(
            child: ListTile(
              title: Text(entry.key),
              subtitle: Text(type),
              trailing: Text(entry.value),
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
