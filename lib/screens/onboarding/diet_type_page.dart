import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class DietTypePage extends StatelessWidget {
  final UserModel userData;
  final Function(String) onDietTypeChanged;

  const DietTypePage({
    Key? key,
    required this.userData,
    required this.onDietTypeChanged,
  }) : super(key: key);

  final List<String> _dietTypes = const [
    'Cân bằng',
    'Giàu protein',
    'Ít carb',
    'Ăn chay',
    'Thuần chay',
    'Keto',
    'Paleo',
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
              'Chế độ ăn',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Chọn chế độ ăn phù hợp với bạn',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            _buildDietTypeSelection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDietTypeSelection() {
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
        children: _dietTypes.map((dietType) {
          final isSelected = userData.dietType == dietType.toLowerCase();

          return GestureDetector(
            onTap: () => onDietTypeChanged(dietType.toLowerCase()),
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
                  Text(
                    dietType,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          isSelected ? const Color(0xFF1A73E8) : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
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
}
