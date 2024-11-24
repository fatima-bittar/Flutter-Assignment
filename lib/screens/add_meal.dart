import 'package:flutter/material.dart';
import '../services/meal_services.dart'; // Import the MealService
import '../models/meal_model.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _thumbUrlController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();

  final MealService _mealService = MealService();

  // Fetch meals using the service (if needed)
  void _fetchLibraryMeals() async {
    try {
      final mealsFromDb = await _mealService.getAllMeals(); // Use the service to fetch meals
      setState(() {
        mealsFromDb; // No need to map manually as MealService returns a List of Meals
      });
    } catch (e) {
      print("Error fetching meals: $e");
    }
  }

  void _saveMeal() async {
    final name = _nameController.text;
    final category = _categoryController.text;
    final thumbUrl = _thumbUrlController.text;
    final instructions = _instructionsController.text;
    final ingredients = _ingredientsController.text;

    if (name.isEmpty || category.isEmpty || instructions.isEmpty || ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    // Generate unique ID for the meal
    String generateIdMeal() {
      return DateTime.now().millisecondsSinceEpoch.toString();
    }

    final mealData = {
      'idMeal': generateIdMeal(),
      'strMeal': name,
      'strCategory': category,
      'strMealThumb': thumbUrl,
      'strInstructions': instructions,
      'ingredients': ingredients, // Add ingredients field
    };

    // Use the service to save the meal
    final success = await _mealService.addMeal(mealData);
    if (success) {
      Navigator.pop(context, true); // true indicates a new meal was added
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save meal")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Meal"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Meal Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _thumbUrlController,
              decoration: const InputDecoration(labelText: "Thumbnail URL"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _instructionsController,
              decoration: const InputDecoration(labelText: "Instructions"),
              maxLines: 3, // Allows for multi-line input
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ingredientsController,
              decoration: const InputDecoration(labelText: "Ingredients (comma-separated)"),
              maxLines: 2, // Allows for multi-line input
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _saveMeal,
                child: const Text("Save Meal")
            ),
          ],
        ),
      ),
    );
  }
}
