import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class NutritionChart extends StatefulWidget {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const NutritionChart({
    Key? key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  }) : super(key: key);

  @override
  _NutritionChartState createState() => _NutritionChartState();
}

class _NutritionChartState extends State<NutritionChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Màu sắc đẹp hơn cho biểu đồ
  final Color proteinColor = const Color(0xFFFF6B6B);
  final Color carbsColor = const Color(0xFF48DBFB);
  final Color fatColor = const Color(0xFFFECA57);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tính tổng giá trị dinh dưỡng
    final total = widget.protein + widget.carbs + widget.fat;

    // Tính phần trăm
    final proteinPercent = (widget.protein / total * 100).round();
    final carbsPercent = (widget.carbs / total * 100).round();
    final fatPercent = (widget.fat / total * 100).round();

    // Tính lượng calo còn lại trong ngày (giả sử mục tiêu là 2500 calo)
    final targetCalories = 2500.0;
    final remainingCalories = targetCalories - widget.calories;
    final caloriesPercent =
        (widget.calories / targetCalories * 100).clamp(0, 100).round();

    // Sửa lỗi overflow bằng cách điều chỉnh margin và padding
    // Thay đổi margin từ symmetric(horizontal: 20) thành all(16)
    // và điều chỉnh padding từ all(20) thành all(16)

    return Container(
      margin: const EdgeInsets.all(14), // Giảm từ 16 xuống 14
      padding: const EdgeInsets.all(14), // Giảm từ 16 xuống 14
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A73E8).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.pie_chart,
                  color: Color(0xFF1A73E8),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Chỉ tiêu dinh dưỡng hôm nay',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A73E8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Biểu đồ calo
          _buildCaloriesProgressBar(caloriesPercent, remainingCalories),

          const SizedBox(height: 25),

          // Biểu đồ tròn và thông tin
          Row(
            children: [
              // Biểu đồ tròn
              Expanded(
                flex: 5, // Thay đổi từ 3 xuống 5
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return SizedBox(
                      height: 160, // Giảm từ 180 xuống 160
                      child: Stack(
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 35, // Giảm từ 40 xuống 35
                              sections: [
                                PieChartSectionData(
                                  color: proteinColor,
                                  value: widget.protein * _animation.value,
                                  title: '',
                                  radius: 70, // Giảm từ 80 xuống 70
                                  titleStyle: const TextStyle(fontSize: 0),
                                ),
                                PieChartSectionData(
                                  color: carbsColor,
                                  value: widget.carbs * _animation.value,
                                  title: '',
                                  radius: 70, // Giảm từ 80 xuống 70
                                  titleStyle: const TextStyle(fontSize: 0),
                                ),
                                PieChartSectionData(
                                  color: fatColor,
                                  value: widget.fat * _animation.value,
                                  title: '',
                                  radius: 70, // Giảm từ 80 xuống 70
                                  titleStyle: const TextStyle(fontSize: 0),
                                ),
                              ],
                            ),
                          ),
                          // Hiển thị tổng calo ở giữa
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${(widget.calories * _animation.value).toInt()}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A73E8),
                                  ),
                                ),
                                const Text(
                                  'Calo',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Thông tin chi tiết
              Expanded(
                flex: 4, // Thay đổi từ 2 lên 4
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNutrientInfo('Protein', widget.protein,
                          proteinPercent, proteinColor),
                      const SizedBox(height: 15),
                      _buildNutrientInfo(
                          'Carbs', widget.carbs, carbsPercent, carbsColor),
                      const SizedBox(height: 15),
                      _buildNutrientInfo(
                          'Chất béo', widget.fat, fatPercent, fatColor),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Thông tin bổ sung
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Mục tiêu hàng ngày: ${targetCalories.toInt()} calo. Còn lại: ${remainingCalories.toInt()} calo.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesProgressBar(int percent, double remaining) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tiến độ calo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$percent%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A73E8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            // Nền của thanh tiến độ
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Phần đã hoàn thành
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return FractionallySizedBox(
                  widthFactor:
                      (percent / 100 * _animation.value).clamp(0.0, 1.0),
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1A73E8),
                          const Color(0xFF66B2FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1A73E8).withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          'Còn lại: ${remaining.toInt()} calo',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientInfo(
      String label, double value, int percent, Color color) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(value * _animation.value).toInt()}g',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  '$percent%',
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            // Thanh tiến độ
            Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor:
                      (percent / 100 * _animation.value).clamp(0.0, 1.0),
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
