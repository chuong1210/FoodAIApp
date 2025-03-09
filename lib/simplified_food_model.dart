import 'dart:io';
import 'dart:math';

class FoodPrediction {
  final String foodName;
  final double confidence;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  FoodPrediction({
    required this.foodName,
    required this.confidence,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}

// List of food items with their nutritional information
final List<Map<String, dynamic>> foodDatabase = [
  {
    'name': 'Pizza',
    'calories': 285,
    'protein': 12.2,
    'carbs': 36.0,
    'fat': 10.4,
  },
  {
    'name': 'Hamburger',
    'calories': 354,
    'protein': 20.0,
    'carbs': 40.0,
    'fat': 17.0,
  },
  {'name': 'Sushi', 'calories': 200, 'protein': 9.0, 'carbs': 38.0, 'fat': 0.5},
  {'name': 'Salad', 'calories': 120, 'protein': 3.5, 'carbs': 12.0, 'fat': 7.0},
  {
    'name': 'Pasta',
    'calories': 320,
    'protein': 12.0,
    'carbs': 65.0,
    'fat': 2.0,
  },
  {
    'name': 'Steak',
    'calories': 350,
    'protein': 25.0,
    'carbs': 0.0,
    'fat': 28.0,
  },
  {
    'name': 'Ice Cream',
    'calories': 207,
    'protein': 3.5,
    'carbs': 23.0,
    'fat': 11.0,
  },
];

// For demo purposes, this function simulates a model prediction
// In a real app, you would replace this with actual model inference
Future<FoodPrediction> predictFood(File imageFile) async {
  // Simulate processing time to show the scanning animation
  await Future.delayed(const Duration(seconds: 2));

  // Use a deterministic approach based on the image path
  // This ensures the same image always returns the same prediction
  final random = Random(imageFile.path.hashCode);
  final index = random.nextInt(foodDatabase.length);
  final food = foodDatabase[index];

  // Generate a realistic confidence score
  final confidence = 0.7 + (random.nextDouble() * 0.25);

  return FoodPrediction(
    foodName: food['name'],
    confidence: confidence,
    calories: food['calories'],
    protein: food['protein'],
    carbs: food['carbs'],
    fat: food['fat'],
  );
}
