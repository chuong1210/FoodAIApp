import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const OnboardingScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final UserModel _userData = UserModel();
  int _currentPage = 0;
  DateTime? _selectedDate;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Default values for sliders
  double _height = 170;
  double _weight = 65;
  double _targetWeight = 65;

  final List<String> _dietTypes = [
    'Balanced',
    'High-protein',
    'Low-carb',
    'Vegetarian',
    'Vegan',
    'Keto',
    'Paleo',
  ];

  final List<String> _activityLevels = [
    'Sedentary (little or no exercise)',
    'Light (exercise 1-3 times/week)',
    'Moderate (exercise 3-5 times/week)',
    'Active (exercise 6-7 times/week)',
    'Very Active (intense exercise daily)',
  ];

  final List<String> _commonMedicalConditions = [
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'Celiac Disease',
    'Lactose Intolerance',
    'IBS',
    'None',
  ];

  final List<String> _commonAllergies = [
    'Peanuts',
    'Tree Nuts',
    'Milk',
    'Eggs',
    'Wheat',
    'Soy',
    'Fish',
    'Shellfish',
    'None',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();

    // Initialize user data with default slider values
    _userData.height = _height;
    _userData.weight = _weight;
    _userData.targetWeight = _targetWeight;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 6) {
      _animationController.reset();
      _pageController
          .nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      )
          .then((_) {
        _animationController.forward();
      });
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _animationController.reset();
      _pageController
          .previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      )
          .then((_) {
        _animationController.forward();
      });
    }
  }

  Future<void> _completeOnboarding() async {
    // Save user data
    await UserService.saveUserData(_userData);
    await UserService.setOnboardingComplete();

    if (!mounted) return;

    // Navigate to home screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(cameras: widget.cameras),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A73E8),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // You can add birthDate to your UserModel if needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A73E8).withOpacity(0.8),
                  const Color(0xFF66B2FF).withOpacity(0.3),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Progress indicator
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / 7,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                      _animationController.forward(from: 0.0);
                    },
                    children: [
                      _buildHeightWeightPage(),
                      _buildGenderAndBirthDatePage(),
                      _buildMedicalConditionsPage(),
                      _buildAllergiesPage(),
                      _buildDietTypePage(),
                      _buildTargetWeightPage(),
                      _buildActivityLevelPage(),
                    ],
                  ),
                ),

                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      _currentPage > 0
                          ? TextButton(
                              onPressed: _previousPage,
                              child: const Text(
                                'Quay lại',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : const SizedBox(width: 80),

                      // Next/Complete button
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1A73E8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          _currentPage < 6 ? 'Tiếp tục' : 'Hoàn thành',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightWeightPage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chiều cao & Cân nặng',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Hãy cho chúng tôi biết chiều cao và cân nặng hiện tại của bạn',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // Height slider
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Chiều cao (cm)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                        Text(
                          '${_height.toInt()} cm',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF1A73E8),
                        inactiveTrackColor: Colors.grey[200],
                        thumbColor: const Color(0xFF1A73E8),
                        overlayColor: const Color(0xFF1A73E8).withOpacity(0.2),
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 12),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 24),
                      ),
                      child: Slider(
                        min: 120,
                        max: 220,
                        divisions: 100,
                        value: _height,
                        onChanged: (value) {
                          setState(() {
                            _height = value;
                            _userData.height = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('120 cm', style: TextStyle(color: Colors.grey)),
                        Text('220 cm', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Weight slider
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cân nặng (kg)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                        Text(
                          '${_weight.toInt()} kg',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF1A73E8),
                        inactiveTrackColor: Colors.grey[200],
                        thumbColor: const Color(0xFF1A73E8),
                        overlayColor: const Color(0xFF1A73E8).withOpacity(0.2),
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 12),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 24),
                      ),
                      child: Slider(
                        min: 30,
                        max: 150,
                        divisions: 120,
                        value: _weight,
                        onChanged: (value) {
                          setState(() {
                            _weight = value;
                            _userData.weight = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('30 kg', style: TextStyle(color: Colors.grey)),
                        Text('150 kg', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderAndBirthDatePage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thông tin cá nhân',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Hãy cho chúng tôi biết giới tính và ngày sinh của bạn',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // Gender selection
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Giới tính',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A73E8),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderOption('Nam', 'male', Icons.male),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child:
                              _buildGenderOption('Nữ', 'female', Icons.female),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildGenderOption('Khác', 'other', Icons.person),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Date of birth
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ngày sinh',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A73E8),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'Chọn ngày sinh'
                                  : DateFormat('dd/MM/yyyy')
                                      .format(_selectedDate!),
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedDate == null
                                    ? Colors.grey[600]
                                    : Colors.black87,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: Color(0xFF1A73E8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String label, String value, IconData icon) {
    final isSelected = _userData.gender == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _userData.gender = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A73E8) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                isSelected ? Colors.transparent : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1A73E8).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 50,
              color: isSelected ? Colors.white : const Color(0xFF1A73E8),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalConditionsPage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
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
                'Chọn các tình trạng sức khỏe mà bạn đang gặp phải',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // Medical conditions selection
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: _commonMedicalConditions.map((condition) {
                    final isSelected =
                        _userData.medicalConditions.contains(condition);

                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (condition == 'None') {
                            if (!_userData.medicalConditions.contains('None')) {
                              _userData.medicalConditions = ['None'];
                            } else {
                              _userData.medicalConditions.remove('None');
                            }
                          } else {
                            if (_userData.medicalConditions
                                .contains(condition)) {
                              _userData.medicalConditions.remove(condition);
                            } else {
                              _userData.medicalConditions.add(condition);
                              _userData.medicalConditions.remove('None');
                            }
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1A73E8)
                                      : Colors.grey.withOpacity(0.5),
                                  width: 2,
                                ),
                                color: isSelected
                                    ? const Color(0xFF1A73E8)
                                    : Colors.transparent,
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
                              condition,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllergiesPage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
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

              // Allergies selection
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: _commonAllergies.map((allergy) {
                    final isSelected = _userData.allergies.contains(allergy);

                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (allergy == 'None') {
                            if (!_userData.allergies.contains('None')) {
                              _userData.allergies = ['None'];
                            } else {
                              _userData.allergies.remove('None');
                            }
                          } else {
                            if (_userData.allergies.contains(allergy)) {
                              _userData.allergies.remove(allergy);
                            } else {
                              _userData.allergies.add(allergy);
                              _userData.allergies.remove('None');
                            }
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1A73E8)
                                      : Colors.grey.withOpacity(0.5),
                                  width: 2,
                                ),
                                color: isSelected
                                    ? const Color(0xFF1A73E8)
                                    : Colors.transparent,
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
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDietTypePage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
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

              // Diet type selection
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: _dietTypes.map((dietType) {
                    final isSelected =
                        _userData.dietType == dietType.toLowerCase();

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _userData.dietType = dietType.toLowerCase();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1A73E8)
                                      : Colors.grey.withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: isSelected ? 12 : 0,
                                  height: isSelected ? 12 : 0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF1A73E8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              dietType,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetWeightPage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cân nặng mục tiêu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Hãy cho chúng tôi biết cân nặng mà bạn muốn đạt được',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // Target weight slider
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cân nặng mục tiêu (kg)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                        Text(
                          '${_targetWeight.toInt()} kg',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF1A73E8),
                        inactiveTrackColor: Colors.grey[200],
                        thumbColor: const Color(0xFF1A73E8),
                        overlayColor: const Color(0xFF1A73E8).withOpacity(0.2),
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 12),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 24),
                      ),
                      child: Slider(
                        min: 30,
                        max: 150,
                        divisions: 120,
                        value: _targetWeight,
                        onChanged: (value) {
                          setState(() {
                            _targetWeight = value;
                            _userData.targetWeight = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('30 kg', style: TextStyle(color: Colors.grey)),
                        Text('150 kg', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Current weight display
              if (_userData.weight != null)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Cân nặng hiện tại của bạn: ${_userData.weight!.toInt()} kg',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityLevelPage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
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

              // Activity level selection
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: _activityLevels.asMap().entries.map((entry) {
                    final index = entry.key;
                    final activityLevel = entry.value;
                    final value = _getActivityLevelValue(index);
                    final isSelected = _userData.activityLevel == value;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _userData.activityLevel = value;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1A73E8)
                                      : Colors.grey.withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: isSelected ? 12 : 0,
                                  height: isSelected ? 12 : 0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF1A73E8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                activityLevel,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
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
