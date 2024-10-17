import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'favorite_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favorites(id INTEGER PRIMARY KEY, name TEXT, species TEXT, gender TEXT, origin TEXT, location TEXT, image TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertFavorite(FavoriteCharacter character) async {
    final db = await database;
    await db.insert('favorites', character.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteFavorite(int id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FavoriteCharacter>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return FavoriteCharacter(
        id: maps[i]['id'],
        name: maps[i]['name'],
        species: maps[i]['species'],
        gender: maps[i]['gender'],
        origin: maps[i]['origin'],
        location: maps[i]['location'],
        image: maps[i]['image'],
      );
    });
  }
}
