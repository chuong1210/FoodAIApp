import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class AllergiesPage extends StatelessWidget {
  final UserModel userData;
  final Function(String) onAllergyToggled;

  const AllergiesPage({
    Key? key,
    required this.userData,
    required this.onAllergyToggled,
  }) : super(key: key);

  final List<String> _commonAllergies = const [
    'Lạc',
    'Các loại hạt',
    'Sữa',
    'Trứng',
    'Lúa mì',
    'Đậu nành',
    'Cá',
    'Hải sản có vỏ',
    'Không có dị ứng',
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
              'Dị ứng thực phẩm',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Chọn các loại thực phẩm mà bạn bị dị ứng',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            _buildAllergiesSelection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergiesSelection() {
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
        children: _commonAllergies.map((allergy) {
          final isSelected = userData.allergies.contains(allergy);

          return GestureDetector(
            onTap: () => onAllergyToggled(allergy),
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
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1A73E8)
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    allergy,
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
