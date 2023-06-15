import 'dart:async';
import 'dart:developer';

import 'package:fitness_tracker_app/model/food_log.dart';
import 'package:fitness_tracker_app/model/user.dart';
import 'package:fitness_tracker_app/model/running_activity_model.dart';
import 'package:fitness_tracker_app/model/running_goal_model.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabase{

  static final UserDatabase instance = UserDatabase.init();

  static Database? _database;

  //private constructor
  UserDatabase.init();

  static const String columnId = 'id';
  static const String columnDistance = 'distance';
  static const String columnDuration = 'duration';

  Future<Database> get database async{
    //check if database already exists
    if(_database != null){
      return _database!;
    }

    //if not then initialise the database
    _database = await _initDB('user.db');
    return _database!;

  }

  //initialise database
  Future<Database> _initDB(String filePath) async{
    //get default database location
    final dbPath = await getDatabasesPath();
    //join the path to our user.db
    final path = join(dbPath, filePath);
    //open our database
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }


  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final intType = 'INTEGER NOT NULL';
    final doubleType = 'DOUBLE NOT NULL';

    await db.execute('''
    CREATE TABLE $tableUser (
    ${UserFields.id} $idType,
    ${UserFields.name} $textType,
    ${UserFields.age} $intType,
    ${UserFields.weight} $doubleType,
    ${UserFields.height} $doubleType,
    ${UserFields.goal} $textType,
    ${UserFields.targetCalories} $intType,
    ${UserFields.currentCalories} $intType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableFood (
    ${FoodFields.id} $idType,
    ${FoodFields.foodName} $textType,
    ${FoodFields.calories} $intType,
    ${FoodFields.date} $textType,
    ${FoodFields.time} $textType
    )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableActivities (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDistance REAL,
        $columnDuration INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableGoals (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDistance REAL
      )
    ''');

  }

  Future<User> createUser(User user) async{
    //access the database
    final db = await instance.database;

    //insert the data into tableUser
    final id = await db.insert(tableUser, user.toJson());

    return user.copy(id: id);
  }

  Future<User> readUser(int id) async {
    //access the database
    final db = await instance.database;
    final maps = await db.query(
        tableUser,
        columns: UserFields.values,
        where: '${UserFields.id} = ?',
        whereArgs: [id],
    );

    if(maps.isNotEmpty){
      return User.fromJson(maps.first);
    }
    else{
      throw Exception('ID $id not found');
    }

  }

  Future<List<User>> readAllUser() async {
    //access the database
    final db = await instance.database;

    final orderBy = '${UserFields.id} ASC';
    final result = await db.query(tableUser, orderBy: orderBy);

    //return a list of all the users
    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return db.update(
      tableUser,
      user.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableUser,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllUser() async {
    final db = await instance.database;
    return await db.delete(
      tableUser,
    );
  }

  Future<bool> checkUser() async {
    //access the database
    final db = await instance.database;
    bool existUser = false;
    final maps = await db.query(
      tableUser,
      columns: UserFields.values,
    );

    if(maps.isNotEmpty){
      existUser = true;
      //return User.fromJson(maps.first);
    }

    return existUser;

  }

  Future<User> getUser() async {
    //access the database
    final db = await instance.database;
    final maps = await db.query(
      tableUser,
      columns: UserFields.values,
    );

    if(maps.isNotEmpty){
      return User.fromJson(maps.first);
    }
    else{
      throw Exception('No user');
    }

  }

  Future<int> updateUserCurrentCalories(User user, int calories) async {
    final db = await instance.database;
    return db.rawUpdate('''
      UPDATE ${tableUser}
      SET currentCalories = ${calories}
      WHERE ${UserFields.id} = ${user.id};
    ''');

  }

  Future<int> updateUserDetails(User user, int age, double weight, double height, String goal) async {
    final db = await instance.database;

    return db.rawUpdate('''
      UPDATE ${tableUser}
      SET age = ${age}, weight = ${weight}, height = ${height}, goal = '${goal}' 
      WHERE ${UserFields.id} = ${user.id};
    ''');

  }

  Future<int> updateUserTargetCalories(User user, int calories) async {
    final db = await instance.database;
    return db.rawUpdate('''
      UPDATE ${tableUser}
      SET targetCalories = ${calories}
      WHERE ${UserFields.id} = ${user.id};
    ''');

  }

  Future<int> updateUserTest(User user, int age, double weight, double height, String goal) async {
    final db = await instance.database;
    return db.rawUpdate('''
      UPDATE ${tableUser}
      SET age = ${age}, weight = ${weight}, height = ${height}, goal = '${goal}' 
      WHERE ${UserFields.id} = ${user.id};
    ''');

  }

  Future<Food> createFood(Food food) async{
    //access the database
    final db = await instance.database;

    //insert the data into tableUser
    final id = await db.insert(tableFood, food.toJson());

    return food.copy(id: id);
  }

  Future<Food> readFood(int id) async {
    //access the database
    final db = await instance.database;
    final maps = await db.query(
      tableFood,
      columns: FoodFields.values,
      where: '${FoodFields.id} = ?',
      whereArgs: [id],
    );

    if(maps.isNotEmpty){
      return Food.fromJson(maps.first);
    }
    else{
      throw Exception('ID $id not found');
    }

  }

  Future<List<Food>> readFoodUsingDate(String date) async {
    //access the database
    final db = await instance.database;
    final orderBy = '${FoodFields.id} ASC';
    final result = await db.query(
      tableFood,
      columns: FoodFields.values,
      where: '${FoodFields.date} = ?',
      whereArgs: [date],
      orderBy: orderBy,
    );

    if(result.isNotEmpty){
      //return a list of all the food
      return result.map((json) => Food.fromJson(json)).toList();
    }
    else{
      throw Exception('No food today');
    }

  }

  Future<List<Food>> readAllFood() async {
    //access the database
    final db = await instance.database;

    final orderBy = '${FoodFields.id} ASC';
    final result = await db.query(tableFood, orderBy: orderBy);

    //return a list of all the food
    return result.map((json) => Food.fromJson(json)).toList();
  }

  Future<int> updateFood(Food food) async {
    final db = await instance.database;
    return db.update(
      tableFood,
      food.toJson(),
      where: '${FoodFields.id} = ?',
      whereArgs: [food.id],
    );
  }

  Future<int> deleteFood(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableFood,
      where: '${FoodFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllFoodToday(String date) async {
    final db = await instance.database;
    return await db.delete(
      tableFood,
      where: '${FoodFields.date} = ?',
      whereArgs: [date],
    );
  }

  Future<int> deleteAllFood() async {
    final db = await instance.database;
    return await db.delete(
      tableFood,
    );
  }

  Future close() async {
    //access the database
    final db = await instance.database;
    //close the database
    db.close();
  }


  Future<List<RunningActivity>> getActivities() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableActivities);
    return List.generate(maps.length, (index) {
      return RunningActivity(
        id: maps[index][columnId],
        distance: maps[index][columnDistance],
        duration: maps[index][columnDuration],
      );
    });
  }

  Future<void> insertActivity(RunningActivity activity) async {
    final db = await database;
    await db.insert(tableActivities, activity.toMap());
  }

  Future<void> deleteActivity(int id) async {
    final db = await database;
    await db.delete(
      tableActivities,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<List<RunningGoal>> getGoals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableGoals);
    return List.generate(maps.length, (index) {
      return RunningGoal(
        id: maps[index][columnId],
        distance: maps[index][columnDistance],
      );
    });
  }

  Future<void> insertGoal(RunningGoal goal) async {
    final db = await database;
    await db.insert(tableGoals, goal.toMap());
  }

  Future<RunningGoal?> getCurrentGoal() async {
    final db = await database;
    final goals = await db.query('goals', orderBy: 'id DESC', limit: 1);
    if (goals.isNotEmpty) {
      return RunningGoal.fromMap(goals.first);
    }
    return null;
  }

  Future<void> updateGoal(RunningGoal goal) async {
    final db = await database;
    await db.update(
      tableGoals,
      goal.toMap(),
      where: '$columnId = ?',
      whereArgs: [goal.id],
    );
  }

}