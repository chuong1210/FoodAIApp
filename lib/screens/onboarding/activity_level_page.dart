import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class ActivityLevelPage extends StatelessWidget {
  final UserModel userData;
  final Function(String) onActivityLevelChanged;

  const ActivityLevelPage({
    Key? key,
    required this.userData,
    required this.onActivityLevelChanged,
  }) : super(key: key);

  final List<String> _activityLevels = const [
    'Ít vận động (ít hoặc không tập thể dục)',
    'Nhẹ nhàng (tập thể dục 1-3 lần/tuần)',
    'Vừa phải (tập thể dục 3-5 lần/tuần)',
    'Năng động (tập thể dục 6-7 lần/tuần)',
    'Rất năng động (tập thể dục cường độ cao hàng ngày)',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mức độ hoạt động',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Chọn mức độ hoạt động thể chất của bạn',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            _buildActivityLevelSelection(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityLevelSelection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: _activityLevels.asMap().entries.map((entry) {
          final index = entry.key;
          final activityLevel = entry.value;
          final value = _getActivityLevelValue(index);
          final isSelected = userData.activityLevel == value;

          return GestureDetector(
            onTap: () => onActivityLevelChanged(value),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1A73E8).withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFF1A73E8) : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFF1A73E8) : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1A73E8)
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      activityLevel,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected
                            ? const Color(0xFF1A73E8)
                            : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getActivityLevelValue(int index) {
    switch (index) {
      case 0:
        return 'sedentary';
      case 1:
        return 'light';
      case 2:
        return 'moderate';
      case 3:
        return 'active';
      case 4:
        return 'very_active';
      default:
        return 'moderate';
    }
  }
}
