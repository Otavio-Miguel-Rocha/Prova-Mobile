import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'emergency_history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE events(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, timestamp TEXT)",
        );
      },
    );
  }

  Future<void> insertEvent(EventModel event) async {
    final db = await database;
    await db.insert('events', event.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<EventModel>> getEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('events', orderBy: "timestamp DESC");
    return List.generate(maps.length, (i) => EventModel.fromMap(maps[i]));
  }
}