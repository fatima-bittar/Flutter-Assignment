import 'dart:convert'; // For decoding JSON
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';
import '../utils/constants.dart';
import '../utils/database_helper.dart';

class MealService {
  /// Fetch meals by name
  Future<List<Meals>> getMealsByName(String name) async {
    try {
      // Search in the database first
      final dbResults = await DatabaseHelper.instance.getMealsByName(name);

      // Convert database results to a list of Meals
      final List<Meals> mealsFromDb = dbResults.map((data) => Meals.fromJson(data)).toList();

      // Otherwise, fetch meals from the API
      final Map<String, dynamic> parameters = {"s": name};
      final url = Uri.https(app_url, '$app_path/search.php', parameters);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // If meals are found in the API response
        if (jsonResponse['meals'] != null) {
          final List<Meals> mealsFromApi = (jsonResponse['meals'] as List)
              .map((mealData) => Meals.fromJson(mealData))
              .toList();
          mealsFromDb.addAll(mealsFromApi);
          return mealsFromDb;
        } else {
          return []; // Return an empty list if no meals are found in the API
        }
      } else {
        throw Exception("Failed to load meals from API");
      }
    } catch (e) {
      print("Error in getMealsByName: $e");
      return [];
    }
  }

  /// Add Meal (to DB)
  Future<bool> addMeal(Map<String, dynamic> mealData) async {
    try {
      await DatabaseHelper.instance.addMeal(mealData); // Call the DB helper to save the meal
      return true;
    } catch (e) {
      print("Error saving meal to database: $e");
      return false;
    }
  }

  /// Edit (Update) an existing meal in the database
  Future<bool> editMeal(Map<String, dynamic> mealData) async {
    try {
      final mealId = mealData['idMeal']; // Assuming 'idMeal' is the primary key
      final existingMeal = await DatabaseHelper.instance.getMealById(mealId);

      if (existingMeal != null) {
        await DatabaseHelper.instance.addMeal(mealData); // Replace existing meal
        return true;
      } else {
        print('Meal not found for editing');
        return false;
      }
    } catch (e) {
      print("Error editing meal: $e");
      return false;
    }
  }

  /// Delete a meal
  Future<bool> deleteMeal(String mealId) async {
    try {
      await DatabaseHelper.instance.deleteMeal(mealId);
      return true;
    } catch (e) {
      print("Error deleting meal: $e");
      return false;
    }
  }

  /// Save meal to database (mark meals as user created if necessary)
  Future<bool> saveMealToDatabase(Map<String, dynamic> mealData, {bool isUserCreated = true}) async {
    try {
      if (isUserCreated) {
        mealData['isUserCreated'] = 1;  // Flag meals added by the user
      } else {
        mealData['isUserCreated'] = 0;  // Flag meals fetched from the API
      }
      await DatabaseHelper.instance.addMeal(mealData);
      return true;
    } catch (e) {
      print("Error saving meal to database: $e");
      return false;
    }
  }

  /// Get all user-created meals
  Future<List<Meals>> getUserCreatedMeals() async {
    try {
      final dbResults = await DatabaseHelper.instance.getAllMeals();
      final userMeals = dbResults
          .where((meal) => meal['isUserCreated'] == 1) // Filter for user-created meals
          .map((mealData) => Meals.fromJson(mealData))
          .toList();
      return userMeals;
    } catch (e) {
      print("Error fetching user meals: $e");
      return [];
    }
  }
  /// Fetch all meals from the local database
  Future<List<Meals>> getAllMeals() async {
    try {
      final dbResults = await DatabaseHelper.instance.getAllMeals();
      // Convert the database result to a list of Meals
      final List<Meals> mealsFromDb = dbResults.map((data) => Meals.fromJson(data)).toList();
      return mealsFromDb;
    } catch (e) {
      print("Error fetching meals from DB: $e");
      return [];
    }
  }
  /// Clear all meals in the database
  Future<void> clearDatabase() async {
    try {
      await DatabaseHelper.instance.clearDatabase();
    } catch (e) {
      print("Error clearing database: $e");
      throw Exception("Failed to clear the database");
    }
  }
}

