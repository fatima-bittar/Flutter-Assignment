import 'package:flutter/material.dart';
import '../screens/login_screen.dart'; // Login screen
import '../screens/home_screen.dart'; // Home screen
import '../screens/meals_details.dart'; // Meal detail screen
import '../screens/add_meal.dart'; // Add meal screen
import '../models/meal_model.dart';
import '../screens/search_screen.dart';

class AppRouter {
  static const String login = '/';
  static const String home = '/home';
  static const String mealDetail = '/meal-detail';
  static const String addMeal = '/add-meal'; // Add meal route
  static const String searchMeal = '/search-meal';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case mealDetail:
      // Retrieve the meal data passed to the route
        final meal = settings.arguments as Meals;
        return MaterialPageRoute(
          builder: (_) => MealDetailScreen(meal: meal),
        );
      case addMeal:
        return MaterialPageRoute(builder: (_) => const AddMealScreen());// Add MealScreen route
      case searchMeal:
        return MaterialPageRoute(builder: (_) =>  SearchScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
