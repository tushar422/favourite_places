import 'package:favourite_places/model/place.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;
  static const String _dbName = 'placesdb.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE place(id TEXT PRIMARY KEY, '
          'title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return _database!;
  }

  Future<List<Place>> getPlaces() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('place');

    return List.generate(maps.length, (i) {
      return Place.fromMap(maps[i]);
    });
  }

  Future<void> insertPlace(Place place) async {
    final db = await database;
    await db.insert('place', place.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
    print('${place.title} place inserted.');
  }
}
