import 'package:flutter/material.dart';

class SelectableOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCheckbox;

  const SelectableOption({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.isCheckbox = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1A73E8).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1A73E8)
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Checkbox or Radio button
              if (isCheckbox)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1A73E8) : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                )
              else
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1A73E8) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
              const SizedBox(width: 12),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        isSelected ? const Color(0xFF1A73E8) : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
