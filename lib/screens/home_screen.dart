import 'package:first_project/screens/add_meal.dart';
import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../services/meal_services.dart';
import './meals_details.dart';
import '../utils/database_helper.dart';
import '../navigation/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override

  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  void _fetchMealsFromDb() async {
    final mealsFromDb = await DatabaseHelper.instance.getAllMeals();
    setState(() {
      meals = mealsFromDb.map((meal) => Meals.fromJson(meal)).toList();
    });
  }

  //Delete meal by ID
  void _deleteMeal(String idMeal) async {
    await DatabaseHelper.instance.deleteMeal(idMeal);
    _fetchMealsFromDb();  // Refresh the list after deletion
  }
  @override
  void initState() {
    super.initState();
    _fetchMealsFromDb();// Fetch meals when the screen loads
  }


  List<Meals> meals = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  // Function to trigger the search
  Future<void> _searchMeals(String mealName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      MealService mealService = MealService();
      List<Meals> fetchedMeals = await mealService.getMealsByName(mealName);
      setState(() {
        meals = fetchedMeals;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load meals: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Application'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _searchMeals(_searchController.text);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search Meals',
              ),
              onSubmitted: _searchMeals,
            ),
          ),
          // Loading Indicator
          if (_isLoading)
            const CircularProgressIndicator()
          else
          // Meal List
            Expanded(
              child: meals.isEmpty
                  ? const Center(
                child: Text(
                  "No meals found. Try searching for something else!",
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
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
                        Navigator.pushNamed(context, AppRouter.mealDetail);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteMeal(meal.idMeal!);  // Delete the meal from the database
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          FloatingActionButton(
            onPressed: () async {
              final added = await Navigator.pushNamed(context, AppRouter.addMeal);

              if (added == true) {
                _fetchMealsFromDb(); // Refresh the list after adding a meal
              }
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
