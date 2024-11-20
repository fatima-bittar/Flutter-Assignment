class Meal {
  List<Meals>? meals;

  Meal({this.meals});

  Meal.fromJson(Map<String, dynamic> json) {
    if (json['meals'] != null) {
      meals = <Meals>[];
      json['meals'].forEach((v) {
        meals!.add(Meals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (meals != null) {
      data['meals'] = meals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meals {
  String? idMeal;
  String? strMeal;
  String? strCategory;
  String? strArea;
  String? strInstructions;
  String? strMealThumb;
  String? strTags;
  String? strYoutube;
  List<String?> ingredients = [];
  List<String?> measures = [];

  Meals({
    this.idMeal,
    this.strMeal,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strTags,
    this.strYoutube,
    required this.ingredients,
    required this.measures,
  });

  // Method to get ingredient at a particular index
  String? getIngredient(int index) {
    if (index < ingredients.length) {
      return ingredients[index];
    }
    return null;
  }

  // Method to get measure at a particular index
  String? getMeasure(int index) {
    if (index < measures.length) {
      return measures[index];
    }
    return null;
  }

  // Factory method to create Meals from JSON
  Meals.fromJson(Map<String, dynamic> json) {
    idMeal = json['idMeal'];
    strMeal = json['strMeal'];
    strCategory = json['strCategory'];
    strArea = json['strArea'];
    strInstructions = json['strInstructions'];
    strMealThumb = json['strMealThumb'];
    strTags = json['strTags'];
    strYoutube = json['strYoutube'];

    // Dynamically build lists of ingredients and measures
    ingredients = List.generate(20, (index) => json['strIngredient${index + 1}']);
    measures = List.generate(20, (index) => json['strMeasure${index + 1}']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['idMeal'] = this.idMeal;
    data['strMeal'] = this.strMeal;
    data['strCategory'] = this.strCategory;
    data['strArea'] = this.strArea;
    data['strInstructions'] = this.strInstructions;
    data['strMealThumb'] = this.strMealThumb;
    data['strTags'] = this.strTags;
    data['strYoutube'] = this.strYoutube;

    // Convert lists of ingredients and measures into their corresponding map fields
    for (int i = 0; i < 20; i++) {
      data['strIngredient${i + 1}'] = ingredients[i];
      data['strMeasure${i + 1}'] = measures[i];
    }

    return data;
  }
}
