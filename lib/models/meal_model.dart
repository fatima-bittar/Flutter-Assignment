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
  int? isUserCreated;
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
    required this.isUserCreated,
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
    isUserCreated = json['isUserCreated'] ?? 0;
    // Dynamically build lists of ingredients and measures
    ingredients = List.generate(20, (index) => json['strIngredient${index + 1}']);
    measures = List.generate(20, (index) => json['strMeasure${index + 1}']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['idMeal'] = idMeal;
    data['strMeal'] = strMeal;
    data['strCategory'] = strCategory;
    data['strArea'] = strArea;
    data['strInstructions'] = strInstructions;
    data['strMealThumb'] = strMealThumb;
    data['strTags'] = strTags;
    data['isUserCreated'] = isUserCreated;
    data['strYoutube'] = strYoutube;

    // Convert lists of ingredients and measures into their corresponding map fields
    for (int i = 0; i < 20; i++) {
      data['strIngredient${i + 1}'] = ingredients[i];
      data['strMeasure${i + 1}'] = measures[i];
    }

    return data;
  }
  // Convert the Meals object to a map for SQLite storage
  Map<String, dynamic> toMap({bool isUserCreated = false}) {
    return {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strCategory': strCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strMealThumb': strMealThumb,
      'strTags': strTags,
      'strYoutube': strYoutube,
      'isUserCreated': isUserCreated ? 1 : 0, // Store as 1 or 0 for SQLite
      // Combine ingredients and measures into a string format (e.g., JSON or CSV)
      'ingredients': ingredients.join(','), // Comma-separated values (you can also use JSON)
      'measures': measures.join(','),
    };
  }

  // Method to convert map data into a Meals object (from the database)
  factory Meals.fromMap(Map<String, dynamic> map) {
    return Meals(
      idMeal: map['idMeal'],
      strMeal: map['strMeal'],
      strCategory: map['strCategory'],
      strArea: map['strArea'],
      strInstructions: map['strInstructions'],
      strMealThumb: map['strMealThumb'],
      strTags: map['strTags'],
      strYoutube: map['strYoutube'],
      isUserCreated: map['isUserCreated'] == 1 ? 1 : 0, // Convert back from 1/0 to bool
      ingredients: map['ingredients']?.split(',') ?? [], // Convert comma-separated values back to list
      measures: map['measures']?.split(',') ?? [], // Same for measures
    );
  }
}
