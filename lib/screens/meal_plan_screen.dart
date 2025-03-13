import 'package:flutter/material.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({Key? key}) : super(key: key);

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  int _selectedDay = 0;
  final List<String> _days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

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
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A73E8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    calories,
                    style: const TextStyle(
                      color: Color(0xFF1A73E8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Thành phần:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...ingredients.map((ingredient) => Padding(
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
              ],
            ),
          ),
        ],
      ),
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
            _buildExerciseItem('Chạy bộ', '30 phút', '150 kcal'),
            _buildExerciseItem('Yoga', '20 phút', '80 kcal'),
            _buildExerciseItem('Đạp xe', '15 phút', '70 kcal'),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(String name, String duration, String calories) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A73E8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  duration,
                  style: const TextStyle(
                    color: Color(0xFF1A73E8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  calories,
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
    );
  }
}
