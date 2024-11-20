import 'package:flutter/material.dart';
import '../screens/login_screen.dart'; // Login screen
import '../screens/home_screen.dart'; // Home screen
import '../screens/meals_details.dart'; // Meal detail screen
import '../models/meal_model.dart';

class AppRouter {
  static const String login = '/';
  static const String home = '/home';
  static const String mealDetail = '/meal-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case mealDetail:
      // Retrieve the meal data passed to the route
        final meal = settings.arguments as Meals;
        return MaterialPageRoute(
          builder: (_) => MealDetailScreen(meal: meal),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
