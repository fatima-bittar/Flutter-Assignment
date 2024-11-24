import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/meal_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Private constructor
  DatabaseHelper._init();

  // Get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;  // Return the existing database
    _database = await _initDB('meals.db');    // Otherwise, initialize it
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3, // Increment version for the new column
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE meals(
            idMeal TEXT PRIMARY KEY,
            strMeal TEXT,
            strCategory TEXT,
            strInstructions TEXT,
            strMealThumb TEXT,
            ingredients TEXT,
            isUserCreated INTEGER DEFAULT 0
          )
          ''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('ALTER TABLE meals ADD COLUMN ingredients TEXT');
        }
        if (oldVersion < 3) {
          db.execute('ALTER TABLE meals ADD COLUMN isUserCreated INTEGER DEFAULT 0');
        }
      },
    );
  }

  // Add a meal
  Future<bool> addMeal(Map<String, dynamic> meal) async {
    try {
      final db = await instance.database;
      await db.insert('meals', meal, conflictAlgorithm: ConflictAlgorithm.replace);
      final allMeals = await DatabaseHelper.instance.getAllMeals();
      print(allMeals); // This is for debugging
      return true; // Indicate success
    } catch (e) {
      print("Error adding meal to database: $e");
      return false; // Indicate failure
    }
  }

  // Get all meals
  Future<List<Map<String, dynamic>>> getAllMeals() async {
    final db = await instance.database;
    return await db.query('meals');
  }

  // Get meal by ID
  Future<Map<String, dynamic>?> getMealById(String id) async {
    final db = await instance.database;
    final result = await db.query('meals', where: 'idMeal = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Delete a meal
  Future<void> deleteMeal(String id) async {
    final db = await instance.database;
    await db.delete('meals', where: 'idMeal = ?', whereArgs: [id]);
    print('Meal deleted with ID: $id');
  }

  // Clear database
  Future<void> clearDatabase() async {
    final db = await instance.database; // Obtain database instance
    try {
      await db.delete('meals'); // Replace 'meals' with your table name
      print('All data cleared from meals table');
    } catch (e) {
      print('Error clearing meals table: $e');
    }
  }


  // Method to query meals by name
  Future<List<Map<String, dynamic>>> getMealsByName(String name) async {
    final db = await database;
    return await db.query(
      'meals',
      where: 'strMeal LIKE ?',
      whereArgs: ['%$name%'],
    );
  }

  // Get user-created meals
  Future<List<Meals>> getUserCreatedMeals() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query('meals', where: 'isUserCreated = ?', whereArgs: [1]);

    return _mealListFromDb(result);
  }
}

// Convert database rows to Meal objects (helper method)
List<Meals> _mealListFromDb(List<Map<String, dynamic>> dbResult) {
  return dbResult.map((mealData) => Meals.fromJson(mealData)).toList();
}

//Delete by id
Future<void> deleteMealById(String idMeal) async {
  final db = await DatabaseHelper.instance.database; // Get the database instance
  try {
    await db.delete(
      'meals', // Replace with your table name
      where: 'idMeal = ?', // SQL condition to match the meal by its ID
      whereArgs: [idMeal], // Pass the meal ID as an argument
    );
    print('Meal with id $idMeal deleted successfully');
  } catch (e) {
    print('Error deleting meal: $e');
  }
}
// DatabaseHelper: Fetch all meals from the database
Future<List<Map<String, dynamic>>> getAllMeals() async {
  final db = await DatabaseHelper.instance.database; // Assuming you have a database instance
  final List<Map<String, dynamic>> result = await db.query('meals'); // Query your table name
  return result;
}

