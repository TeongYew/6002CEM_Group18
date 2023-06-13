import 'package:fitness_tracker_app/model/running_activity_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'activity_log.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE activities (id INTEGER PRIMARY KEY AUTOINCREMENT, distance REAL, duration INTEGER)',
        );
      },
    );
  }

  Future<void> insertActivity(RunningActivity activity) async {
    final db = await database;
    await db.insert('activities', activity.toMap());
  }

  Future<void> deleteActivity(int id) async {
    final db = await database;
    await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }


  Future<List<RunningActivity>> getActivities() async {
    final db = await database;
    final result = await db.query('activities');

    return result.map((map) => RunningActivity.fromMap(map)).toList();
  }
}
