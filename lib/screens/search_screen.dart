import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../services/meal_services.dart';
import '../navigation/routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Meals> _searchResults = [];
  bool _isLoading = false;

  // Search meals
  void _searchMeals(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      MealService mealService = MealService();
      final results = await mealService.getMealsByName(query); // Using service to search meals
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print("Error fetching search results: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Add meal to local database using the MealService
  void _addToLibrary(Meals meal) async {
    try {
      final success = await MealService().addMeal(meal.toMap()); // Using service to add meal to DB
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${meal.strMeal} added to library')),
        );
        // Pass signal back to HomeScreen to refresh
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add ${meal.strMeal} to library')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding meal to library: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Meals"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search input field
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search Meals',
              ),
              onSubmitted: _searchMeals,
            ),
            const SizedBox(height: 10),
            // Check if loading
            if (_isLoading)
              const CircularProgressIndicator()
            // If search results are found
            else if (_searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final meal = _searchResults[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: meal.strMealThumb != null
                            ? Image.network(meal.strMealThumb!,
                            width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.fastfood),
                        title: Text(meal.strMeal ?? "Unknown Meal"),
                        subtitle: Text(meal.strCategory ?? "Unknown Category"),
                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRouter.mealDetail,
                              arguments: meal);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _addToLibrary(meal),
                        ),
                      ),
                    );
                  },
                ),
              )
            // If no results are found
            else
              const Center(child: Text("No meals found")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, true); // Pass true to indicate changes
        },
        tooltip: 'Go to Library',
        child: const Icon(Icons.library_books),
      ),
    );
  }
}
