import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../services/meal_services.dart';
import '../navigation/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Meals> _libraryMeals = [];
  final MealService _mealService = MealService(); // Create an instance of MealService

  @override
  void initState() {
    super.initState();
    _fetchLibraryMeals(); // Load meals when the screen is initialized
  }

  // Fetch meals from the service
  void _fetchLibraryMeals() async {
    try {
      final allMeals = await _mealService.getAllMeals(); // Use the service to get meals
      setState(() {
        _libraryMeals = allMeals;
      });
    } catch (e) {
      print('Error fetching library meals: $e');
    }
  }

  // Delete a meal using the service
  void _deleteMeal(String idMeal) async {
    try {
      await _mealService.deleteMeal(idMeal); // Use the service to delete a meal
      _fetchLibraryMeals(); // Refresh after deletion
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Meal deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting meal: $e')));
    }
  }

  // Clear all meals from the library using the service
  void _clearLibrary() async {
    try {
      await _mealService.clearDatabase(); // Use the service to clear the database
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Library cleared")));
      _fetchLibraryMeals(); // Refresh library meals
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to clear library: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Meal Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, AppRouter.searchMeal);
              if (result == true) {
                _fetchLibraryMeals(); // Refresh the library if changes occurred
              }
            },
          ),
        ],
      ),
      body: _libraryMeals.isEmpty
          ? const Center(
        child: Text(
          "Your library is empty. Add meals from the search screen!",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: _libraryMeals.length,
        itemBuilder: (context, index) {
          final meal = _libraryMeals[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              leading: meal.strMealThumb != null
                  ? Image.network(
                meal.strMealThumb!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.fastfood),
              title: Text(meal.strMeal ?? "Unknown Meal"),
              subtitle: Text(meal.strCategory ?? "Unknown Category"),
              onTap: () {
                Navigator.pushNamed(context, AppRouter.mealDetail, arguments: meal);
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteMeal(meal.idMeal!), // Delete meal using the service
              ),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Clear library button
          FloatingActionButton(
            onPressed: _clearLibrary,
            tooltip: "Clear Library",
            child: const Icon(Icons.delete_forever),
            backgroundColor: Colors.redAccent,
          ),
          const SizedBox(width: 16),
          // Add meal button
          FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, AppRouter.addMeal);
              if (result == true) {
                _fetchLibraryMeals(); // Refresh the library meals if a new meal was added
              }
            },
            tooltip: "Add Meal",
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
