import 'package:flutter/material.dart';
import '../db/database.dart';
import '../planetas/planetas.dart';

class AddPlanetPage extends StatefulWidget {
  const AddPlanetPage({Key? key}) : super(key: key);

  @override
  State<AddPlanetPage> createState() => _AddPlanetPageState();
}

class _AddPlanetPageState extends State<AddPlanetPage> {
  final _nameController = TextEditingController();
  final _distanceController = TextEditingController();
  final _radiusController = TextEditingController();

  void _addPlanet() async {
    final name = _nameController.text;
    final distance = double.tryParse(_distanceController.text) ?? 0.0;
    final radius = double.tryParse(_radiusController.text) ?? 0.0;

    if (name.isNotEmpty) {
      final planeta = Planetas(
        null, // id is null for new entries
        name,
        distance,
        radius,
      );

      await DB.insertar([planeta]);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Planeta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _distanceController,
              decoration: const InputDecoration(labelText: 'Distancia del sol'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _radiusController,
              decoration: const InputDecoration(labelText: 'Radio'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addPlanet,
              child: const Text('Agregar Planeta'),
            ),
          ],
        ),
      ),
    );
  }
}
