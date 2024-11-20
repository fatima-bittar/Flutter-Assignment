// import 'dart:async';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/meal_model.dart';
//
// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;
//
//   // Private constructor
//   DatabaseHelper._init();
//
//   // Get the database instance
//   Future<Database> get database async {
//     if (_database != null) return _database!;  // Return the existing database
//     _database = await _initDB('meals.db');    // Otherwise, initialize it
//     return _database!;
//   }
//
//
//   // Initialize the database
//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);
//
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         return db.execute(
//           '''
//           CREATE TABLE meals(
//             idMeal TEXT PRIMARY KEY,
//             strMeal TEXT,
//             strCategory TEXT,
//             strInstructions TEXT,
//             strMealThumb TEXT
//           )
//           ''',
//         );
//       },
//     );
//   }
//
//   // Insert a meal
//   Future<void> insertMeal(Map<String, dynamic> meal) async {
//     final db = await instance.database;
//     await db.insert('meals', meal, conflictAlgorithm: ConflictAlgorithm.replace);
//     print('Meal inserted: $meal');  // Log message
//   }
//
//   // Get all meals
//   Future<List<Map<String, dynamic>>> getAllMeals() async {
//     final db = await instance.database;
//     return await db.query('meals');
//   }
//
//   // Get meal by ID
//   Future<Map<String, dynamic>?> getMealById(String id) async {
//     final db = await instance.database;
//     final result = await db.query('meals', where: 'idMeal = ?', whereArgs: [id]);
//     return result.isNotEmpty ? result.first : null;
//   }
//
//   // Delete a meal
//   Future<void> deleteMeal(String id) async {
//     final db = await instance.database;
//     await db.delete('meals', where: 'idMeal = ?', whereArgs: [id]);
//     print('Meal deleted with ID: $id');
//     getAllMeals();
//   }
//
// }
