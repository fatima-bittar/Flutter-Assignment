import 'dart:convert'; // For decoding JSON
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';
import '../utils/constants.dart';

class MealService {
  /// Fetch meals by name
  Future<List<Meals>> getMealsByName(String name) async {
    final Map<String, dynamic> parameters = {"s": name};
    final url = Uri.https(app_url, '$app_path/search.php', parameters);
    final response = await http.get(url);
    print('Request URL: $url');
    print('hellloo Response: ${response.body}');
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      // Extract the 'meals' list from the JSON response
      if (jsonResponse['meals'] != null) {
        return (jsonResponse['meals'] as List)
            .map((mealData) => Meals.fromJson(mealData))
            .toList();
      } else {
        return []; // Return an empty list if no meals are found
      }
    } else {
      print('Error: ${response.statusCode} - ${response.reasonPhrase}');
      throw Exception("Failed to load meals");
    }
  }


  /// Post (create) a new meal
  Future<bool> postMeal(Meal meal) async {
    var url = Uri.https(app_url, '$app_path/save.php');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(meal.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Failed to post meal");
    }
  }

  /// Edit (update) an existing meal
  Future<bool> editMeal(Meals meal) async {  // Changed to 'Meals' instead of 'Meal'
    var url = Uri.https(app_url, '$app_path/save.php/${meal.idMeal}');  // Accessing 'idMeal' from 'Meals'
    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(meal.toJson()),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception("Failed to edit meal");
    }
  }

  /// Delete a meal
  Future<bool> deleteMeal(int mealId) async {
    var url = Uri.https(app_url, '$app_path/delete.php/$mealId');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to delete meal");
    }
  }
}
