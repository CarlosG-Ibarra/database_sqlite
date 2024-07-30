import 'package:flutter/material.dart';
import '../db/database.dart';
import '../planetas/planetas.dart';
import 'add_planet_page.dart';
import 'update_planet_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Planetas>? planetario;

  @override
  void initState() {
    super.initState();
    abrirDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema Solar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPlanetPage()),
              ).then((_) => abrirDB()); // Refresh list after adding
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (planetario == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: planetario!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.blur_circular_rounded),
                    title: Text("Nombre: ${planetario![index].nombre}"),
                    subtitle: Text("Radio: ${planetario![index].radio}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdatePlanetPage(
                                  planeta: planetario![index],
                                ),
                              ),
                            ).then((_) => abrirDB()); // Refresh list after updating
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await DB.borrar(planetario![index].id!);
                            abrirDB(); // Refresh list after deleting
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void abrirDB() {
    DB.db().then((_) async {
      await query();
    });
  }

  Future<void> query() async {
    planetario = await DB.consulta();
    setState(() {});
  }
}
