import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class MedicalConditionsPage extends StatelessWidget {
  final UserModel userData;
  final Function(String) onMedicalConditionToggled;

  const MedicalConditionsPage({
    Key? key,
    required this.userData,
    required this.onMedicalConditionToggled,
  }) : super(key: key);

  final List<String> _commonMedicalConditions = const [
    'Tiểu đường',
    'Huyết áp cao',
    'Bệnh tim mạch',
    'Bệnh celiac',
    'Không dung nạp lactose',
    'Hội chứng ruột kích thích',
    'Không có vấn đề sức khỏe',
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
              'Tình trạng sức khỏe',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Chọn các vấn đề sức khỏe mà bạn đang gặp phải',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            _buildMedicalConditionsSelection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalConditionsSelection() {
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
        children: _commonMedicalConditions.map((condition) {
          final isSelected = userData.medicalConditions.contains(condition);

          return GestureDetector(
            onTap: () => onMedicalConditionToggled(condition),
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
                  Expanded(
                    child: Text(
                      condition,
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
}
