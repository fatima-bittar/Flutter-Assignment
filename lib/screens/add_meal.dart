import 'package:flutter/material.dart';
import '../utils/database_helper.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _thumbUrlController = TextEditingController();

  void _saveMeal() async {
    final name = _nameController.text;
    final category = _categoryController.text;
    final thumbUrl = _thumbUrlController.text;


    if (name.isEmpty || category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and Category cannot be empty")),
      );
      return;
    }

    // Add meal to the database
    await DatabaseHelper.instance.addMeal({
      'strMeal': name,
      'strCategory': category,
      'strMealThumb': thumbUrl,
    });

    // Go back to the previous screen
    Navigator.pop(context, true); // true indicates a new meal was added
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Meal"),
      ),
      body: Padding(
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMeal,
              child: const Text("Save Meal"),
            ),
          ],
        ),
      ),
    );
  }
}
