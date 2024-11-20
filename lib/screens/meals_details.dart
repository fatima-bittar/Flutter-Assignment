import 'package:flutter/material.dart';
import '../models/meal_model.dart';

class MealDetailScreen extends StatelessWidget {
  final Meals meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.strMeal ?? "Meal Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal Image
              meal.strMealThumb != null
                  ? Image.network(meal.strMealThumb!)
                  : const Icon(Icons.fastfood, size: 100),

              const SizedBox(height: 16),

              // Meal Instructions
              Text(
                "Instructions:",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(meal.strInstructions ?? "No instructions available."),

              const SizedBox(height: 16),

              // Ingredients
              Text(
                "Ingredients:",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(20, (index) {
                  final ingredient = meal.getIngredient(index);
                  final measure = meal.getMeasure(index);
                  return (ingredient != null && ingredient.isNotEmpty)
                      ? Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      '$ingredient - $measure',
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                      : Container();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
