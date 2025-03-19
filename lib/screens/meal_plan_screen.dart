import 'package:flutter/material.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({Key? key}) : super(key: key);

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  int _selectedDay = 0;
  final List<String> _days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  // Thêm Map để lưu trữ đánh giá sao cho mỗi bữa ăn
  final Map<String, int> _mealRatings = {
    'breakfast': 0,
    'morning_snack': 0,
    'lunch': 0,
    'afternoon_snack': 0,
    'dinner': 0,
  };

  // Map to track which meals have been completed
  final Map<String, bool> _mealCompleted = {
    'breakfast': false,
    'morning_snack': false,
    'lunch': false,
    'afternoon_snack': false,
    'dinner': false,
  };

  // Map to store replacement meals
  final Map<String, Map<String, dynamic>> _replacementMeals = {};

  // Map to store replacement exercises
  final Map<String, Map<String, dynamic>> _replacementExercises = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildDaySelector(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildMealCard(
                    'Bữa sáng',
                    'Bánh mì trứng và sữa chua',
                    '350 kcal',
                    'breakfast',
                    ['2 lát bánh mì', '2 quả trứng', '1 hộp sữa chua'],
                    const TimeOfDay(hour: 7, minute: 0),
                  ),
                  _buildMealCard(
                    'Bữa nhẹ buổi sáng',
                    'Hoa quả và hạt dinh dưỡng',
                    '150 kcal',
                    'morning_snack',
                    ['1 quả táo', '30g hạt hỗn hợp', '1 ly nước ép'],
                    const TimeOfDay(hour: 10, minute: 0),
                  ),
                  _buildMealCard(
                    'Bữa trưa',
                    'Cơm gà và rau xào',
                    '550 kcal',
                    'lunch',
                    ['150g cơm', '200g gà', '100g rau xào'],
                    const TimeOfDay(hour: 12, minute: 0),
                  ),
                  _buildMealCard(
                    'Bữa nhẹ buổi chiều',
                    'Sữa chua và granola',
                    '200 kcal',
                    'afternoon_snack',
                    ['1 hộp sữa chua', '30g granola', '1 muỗng mật ong'],
                    const TimeOfDay(hour: 15, minute: 0),
                  ),
                  _buildMealCard(
                    'Bữa tối',
                    'Súp rau củ và cá hồi nướng',
                    '450 kcal',
                    'dinner',
                    ['200g cá hồi', '300ml súp rau củ', '100g salad'],
                    const TimeOfDay(hour: 19, minute: 0),
                  ),
                  _buildExerciseCard(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A73E8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kế hoạch dinh dưỡng',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '1350 kcal/ngày',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.fitness_center, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '30 phút/ngày',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = index;
              });
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: _selectedDay == index
                    ? const Color(0xFF1A73E8)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _selectedDay == index
                      ? const Color(0xFF1A73E8)
                      : Colors.grey[300]!,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _days[index],
                    style: TextStyle(
                      color: _selectedDay == index
                          ? Colors.white
                          : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: _selectedDay == index
                          ? Colors.white
                          : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMealCard(String title, String description, String calories,
      String mealType, List<String> ingredients, TimeOfDay time) {
    // Check if this meal has been replaced
    final replacementMeal = _replacementMeals[mealType];

    // Use replacement meal data if available
    final displayDescription =
        replacementMeal != null ? replacementMeal['name'] : description;
    final displayCalories =
        replacementMeal != null ? replacementMeal['calories'] : calories;
    final displayIngredients = replacementMeal != null
        ? List<String>.from(replacementMeal['ingredients'])
        : ingredients;

    // Macronutrient information - either from replacement or default
    final Map<String, dynamic> macros = replacementMeal != null
        ? replacementMeal['macros']
        : _getMacrosForMeal(mealType);

    // Add a badge for replaced meals
    final bool isReplaced = replacementMeal != null;

    // Thêm màu sắc cho các bữa ăn nhẹ
    Color cardColor;
    IconData mealIcon;

    switch (mealType) {
      case 'breakfast':
        cardColor = Colors.orange.withOpacity(0.1);
        mealIcon = Icons.wb_sunny_outlined;
        break;
      case 'morning_snack':
        cardColor = Colors.amber.withOpacity(0.1);
        mealIcon = Icons.apple;
        break;
      case 'lunch':
        cardColor = Colors.green.withOpacity(0.1);
        mealIcon = Icons.restaurant_outlined;
        break;
      case 'afternoon_snack':
        cardColor = Colors.teal.withOpacity(0.1);
        mealIcon = Icons.coffee;
        break;
      case 'dinner':
        cardColor = Colors.blue.withOpacity(0.1);
        mealIcon = Icons.nightlight_outlined;
        break;
      default:
        cardColor = Colors.grey.withOpacity(0.1);
        mealIcon = Icons.restaurant_outlined;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(mealIcon, color: const Color(0xFF1A73E8)),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: Color(0xFF1A73E8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayDescription,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A73E8).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        displayCalories,
                        style: const TextStyle(
                          color: Color(0xFF1A73E8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Star Rating
                    StarRating(
                      mealType: mealType,
                      onRatingChanged: (rating) {
                        // Lưu rating vào state hoặc database
                        print('$mealType rated: $rating');
                        setState(() {
                          _mealRatings[mealType] = rating;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Macronutrient information
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMacroItem(
                          'Protein', macros['protein'], Colors.red[400]!),
                      _buildMacroItem(
                          'Carbs', macros['carbs'], Colors.blue[400]!),
                      _buildMacroItem(
                          'Chất béo', macros['fat'], Colors.amber[400]!),
                    ],
                  ),
                ),

                const Text(
                  'Thành phần:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...displayIngredients.map((ingredient) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              size: 16, color: Color(0xFF1A73E8)),
                          const SizedBox(width: 8),
                          Text(ingredient),
                        ],
                      ),
                    )),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Meal completion checkbox
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _mealCompleted[mealType] =
                              !(_mealCompleted[mealType] ?? false);
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _mealCompleted[mealType] == true
                                  ? const Color(0xFF1A73E8)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _mealCompleted[mealType] == true
                                    ? const Color(0xFF1A73E8)
                                    : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: _mealCompleted[mealType] == true
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _mealCompleted[mealType] == true
                                ? 'Đã hoàn thành'
                                : 'Đánh dấu hoàn thành',
                            style: TextStyle(
                              fontSize: 14,
                              color: _mealCompleted[mealType] == true
                                  ? const Color(0xFF1A73E8)
                                  : Colors.grey[600],
                              fontWeight: _mealCompleted[mealType] == true
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Replace meal button
                    TextButton.icon(
                      onPressed: () {
                        _showReplaceMealDialog(context, mealType, title);
                      },
                      icon: const Icon(
                        Icons.swap_horiz,
                        size: 18,
                      ),
                      label: const Text('Thay đổi'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF1A73E8),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Add this helper method to get macronutrient information for meals
  Map<String, dynamic> _getMacrosForMeal(String mealType) {
    // Default macronutrient values for each meal type
    switch (mealType) {
      case 'breakfast':
        return {'protein': '15g', 'carbs': '40g', 'fat': '10g'};
      case 'morning_snack':
        return {'protein': '5g', 'carbs': '20g', 'fat': '5g'};
      case 'lunch':
        return {'protein': '25g', 'carbs': '60g', 'fat': '15g'};
      case 'afternoon_snack':
        return {'protein': '8g', 'carbs': '25g', 'fat': '7g'};
      case 'dinner':
        return {'protein': '30g', 'carbs': '45g', 'fat': '12g'};
      default:
        return {'protein': '10g', 'carbs': '30g', 'fat': '8g'};
    }
  }

// Add this helper method to display macronutrient information
  Widget _buildMacroItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            label == 'Protein'
                ? Icons.fitness_center
                : label == 'Carbs'
                    ? Icons.grain
                    : Icons.opacity,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.fitness_center, color: Color(0xFF1A73E8)),
                SizedBox(width: 8),
                Text(
                  'Hoạt động thể chất',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildExerciseItem('running', 'Chạy bộ', '30 phút', '150 kcal'),
            _buildExerciseItem('yoga', 'Yoga', '20 phút', '80 kcal'),
            _buildExerciseItem('cycling', 'Đạp xe', '15 phút', '70 kcal'),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(
      String exerciseId, String name, String duration, String calories) {
    // Check if this exercise has been replaced
    final replacementExercise = _replacementExercises[exerciseId];

    // Use replacement exercise data if available
    final displayName =
        replacementExercise != null ? replacementExercise['name'] : name;
    final displayDuration = replacementExercise != null
        ? replacementExercise['duration']
        : duration;
    final displayCalories = replacementExercise != null
        ? replacementExercise['calories']
        : calories;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A73E8).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      displayDuration,
                      style: const TextStyle(
                        color: Color(0xFF1A73E8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      displayCalories,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Exercise completion checkbox
              GestureDetector(
                onTap: () {
                  setState(() {
                    _mealCompleted[exerciseId] =
                        !(_mealCompleted[exerciseId] ?? false);
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _mealCompleted[exerciseId] == true
                            ? const Color(0xFF1A73E8)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _mealCompleted[exerciseId] == true
                              ? const Color(0xFF1A73E8)
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: _mealCompleted[exerciseId] == true
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _mealCompleted[exerciseId] == true
                          ? 'Đã hoàn thành'
                          : 'Đánh dấu hoàn thành',
                      style: TextStyle(
                        fontSize: 14,
                        color: _mealCompleted[exerciseId] == true
                            ? const Color(0xFF1A73E8)
                            : Colors.grey[600],
                        fontWeight: _mealCompleted[exerciseId] == true
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),

              // Replace exercise button
              TextButton.icon(
                onPressed: () {
                  _showReplaceExerciseDialog(context, exerciseId, displayName);
                },
                icon: const Icon(
                  Icons.swap_horiz,
                  size: 18,
                ),
                label: const Text('Thay đổi'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1A73E8),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Add this method to show the exercise replacement dialog
  void _showReplaceExerciseDialog(
      BuildContext context, String exerciseId, String exerciseName) {
    // List of alternative exercises
    final List<Map<String, dynamic>> alternativeExercises = [
      {
        'name': 'Bơi lội',
        'duration': '30 phút',
        'calories': '200 kcal',
      },
      {
        'name': 'Đi bộ',
        'duration': '45 phút',
        'calories': '120 kcal',
      },
      {
        'name': 'Nhảy dây',
        'duration': '15 phút',
        'calories': '150 kcal',
      },
      {
        'name': 'Tập tạ',
        'duration': '40 phút',
        'calories': '180 kcal',
      },
      {
        'name': 'Pilates',
        'duration': '25 phút',
        'calories': '100 kcal',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thay đổi $exerciseName',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm hoạt động...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Gợi ý hoạt động thay thế',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: alternativeExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = alternativeExercises[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A73E8).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                        title: Text(
                          exercise['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text(exercise['duration']),
                            const SizedBox(width: 10),
                            Text(
                              exercise['calories'],
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _replacementExercises[exerciseId] = exercise;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Chọn'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// Update the _showReplaceMealDialog method to include macronutrient information
  void _showReplaceMealDialog(
      BuildContext context, String mealType, String mealTitle) {
    // List of alternative meals with macronutrient information
    final List<Map<String, dynamic>> alternativeMeals = [
      {
        'name': 'Phở bò',
        'description': 'Phở bò truyền thống',
        'calories': '420 kcal',
        'ingredients': ['200g bánh phở', '150g thịt bò', 'Hành, gừng, gia vị'],
        'macros': {'protein': '25g', 'carbs': '65g', 'fat': '10g'},
      },
      {
        'name': 'Cơm gà',
        'description': 'Cơm gà Hải Nam',
        'calories': '480 kcal',
        'ingredients': ['200g cơm', '150g thịt gà', 'Dưa chuột, cà chua'],
        'macros': {'protein': '30g', 'carbs': '70g', 'fat': '12g'},
      },
      {
        'name': 'Bún chả',
        'description': 'Bún chả Hà Nội',
        'calories': '520 kcal',
        'ingredients': [
          '200g bún',
          '150g thịt lợn nướng',
          'Rau sống, nước mắm'
        ],
        'macros': {'protein': '28g', 'carbs': '60g', 'fat': '18g'},
      },
      {
        'name': 'Bánh mì',
        'description': 'Bánh mì thịt',
        'calories': '380 kcal',
        'ingredients': ['1 ổ bánh mì', '100g thịt', 'Rau, đồ chua, pate'],
        'macros': {'protein': '18g', 'carbs': '50g', 'fat': '12g'},
      },
      {
        'name': 'Salad',
        'description': 'Salad trộn dầu giấm',
        'calories': '220 kcal',
        'ingredients': ['150g rau xanh', '50g thịt gà', 'Dầu olive, giấm'],
        'macros': {'protein': '15g', 'carbs': '10g', 'fat': '15g'},
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thay đổi $mealTitle',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm món ăn...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Gợi ý món ăn thay thế',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: alternativeMeals.length,
                  itemBuilder: (context, index) {
                    final meal = alternativeMeals[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        title: Text(
                          meal['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(meal['description']),
                            const SizedBox(height: 5),
                            Text(
                              meal['calories'],
                              style: const TextStyle(
                                color: Color(0xFF1A73E8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _replacementMeals[mealType] = meal;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Chọn'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Thêm class StarRating vào cuối file, trước dấu ngoặc nhọn cuối cùng:

class StarRating extends StatefulWidget {
  final String mealType;
  final Function(int) onRatingChanged;

  const StarRating({
    Key? key,
    required this.mealType,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

// Cập nhật class StarRating để sử dụng giá trị từ _mealRatings

class _StarRatingState extends State<StarRating> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    // Lấy giá trị rating từ state của màn hình cha
    final parentState = context.findAncestorStateOfType<_MealPlanScreenState>();
    _rating = parentState?._mealRatings[widget.mealType] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1;
            });

            // Cập nhật giá trị trong state của màn hình cha
            final parentState =
                context.findAncestorStateOfType<_MealPlanScreenState>();
            if (parentState != null) {
              parentState.setState(() {
                parentState._mealRatings[widget.mealType] = _rating;
              });
            }

            widget.onRatingChanged(_rating);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Icon(
              index < _rating ? Icons.star : Icons.star_border,
              color: const Color(0xFFFFD700),
              size: 20,
            ),
          ),
        );
      }),
    );
  }
}
