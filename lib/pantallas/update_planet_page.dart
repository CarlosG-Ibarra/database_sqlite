import 'package:flutter/material.dart';
import '../db/database.dart';
import '../planetas/planetas.dart';

class UpdatePlanetPage extends StatefulWidget {
  final Planetas planeta;

  const UpdatePlanetPage({Key? key, required this.planeta}) : super(key: key);

  @override
  State<UpdatePlanetPage> createState() => _UpdatePlanetPageState();
}

class _UpdatePlanetPageState extends State<UpdatePlanetPage> {
  late TextEditingController _nameController;
  late TextEditingController _distanceController;
  late TextEditingController _radiusController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.planeta.nombre);
    _distanceController = TextEditingController(text: widget.planeta.distanciaSol.toString());
    _radiusController = TextEditingController(text: widget.planeta.radio.toString());
  }

  void _updatePlanet() async {
    final name = _nameController.text;
    final distance = double.tryParse(_distanceController.text) ?? 0.0;
    final radius = double.tryParse(_radiusController.text) ?? 0.0;

    if (name.isNotEmpty) {
      final updatedPlaneta = Planetas(
        widget.planeta.id,
        name,
        distance,
        radius,
      );

      await DB.actualizar(updatedPlaneta);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Planeta'),
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
              onPressed: _updatePlanet,
              child: const Text('Actualizar Planeta'),
            ),
          ],
        ),
      ),
    );
  }
}
