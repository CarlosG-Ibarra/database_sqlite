import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../planetas/planetas.dart';

class DB {
  // Method to get the path of the database
  static Future<sqlite.Database> db() async {
    // Get the application documents directory
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'solarsystem.db');

    // Open the database with the given path
    return sqlite.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create the 'planeta' table when the database is created
        await db.execute('''
          CREATE TABLE IF NOT EXISTS planeta (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            nombre TEXT NOT NULL,
            distanciaSol REAL NOT NULL,
            radio REAL NOT NULL,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Handle database upgrade if needed
      },
    );
  }

  // Method to insert planets into the database
  static Future<int> insertar(List<Planetas> planetario) async {
    final sqlite.Database db = await DB.db();
    int value = 0;
    for (Planetas planeta in planetario) {
      value = await db.insert(
        "planeta",
        planeta.mapeador(),
        conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
      );
    }
    return value;
  }

  // Method to query planets from the database
  static Future<List<Planetas>> consulta() async {
    final sqlite.Database db = await DB.db();
    final List<Map<String, dynamic>> query = await db.query("planeta");
    List<Planetas> planetario = query.map((e) => Planetas.delMapa(e)).toList();
    return planetario;
  }

  // Method to delete a planet by its ID
  static Future<void> borrar(int id) async {
    final sqlite.Database db = await DB.db();
    await db.delete("planeta", where: "id = ?", whereArgs: [id]);
  }

  // Method to update a planet in the database
  static Future<void> actualizar(Planetas planeta) async {
    final sqlite.Database db = await DB.db();
    await db.update(
      "planeta",
      planeta.mapeador(),
      where: "id = ?",
      whereArgs: [planeta.id],
    );
  }
}
