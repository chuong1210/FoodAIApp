import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';

class OnboardingScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const OnboardingScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final UserModel _userData = UserModel();
  int _currentPage = 0;

  // Controllers for sliders
  double _heightValue = 170;
  double _weightValue = 65;
  double _targetWeightValue = 60;

  // Date of birth
  DateTime _selectedDate = DateTime.now()
      .subtract(const Duration(days: 365 * 25)); // Default to 25 years old

  // Animation controllers
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

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

    // Set initial values for user data
    _userData.height = _heightValue;
    _userData.weight = _weightValue;
    _userData.targetWeight = _targetWeightValue;

    // Initialize animation controller
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 6) {
      // Don't reset animation before transition
      _pageController
          .nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      )
          .then((_) {
        // Reset and start animation only after page transition completes
        _slideController.reset();
        _slideController.forward();
      });
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      // Don't reset animation before transition
      _pageController
          .previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      )
          .then((_) {
        // Reset and start animation only after page transition completes
        _slideController.reset();
        _slideController.forward();
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

  void _showDatePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                  const Text(
                    'Chọn ngày sinh',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: const Text('Xác nhận'),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate,
                  maximumDate: DateTime.now(),
                  minimumDate: DateTime(1900),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Bước ${_currentPage + 1}/7',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (_currentPage + 1) / 7,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 8,
                      ),
                    ],
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
                    },
                    children: [
                      _buildHeightWeightPage(),
                      _buildGenderAndBirthdayPage(),
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
                      if (_currentPage > 0)
                        ElevatedButton.icon(
                          onPressed: _previousPage,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Quay lại'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.3),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 120),

                      // Next/Complete button
                      ElevatedButton.icon(
                        onPressed: _nextPage,
                        icon: _currentPage < 6
                            ? const Icon(Icons.arrow_forward)
                            : const Icon(Icons.check),
                        label: Text(
                          _currentPage < 6 ? 'Tiếp tục' : 'Hoàn thành',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1A73E8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
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
    return SlideTransition(
      position: _slideAnimation,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Chiều cao',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A73E8).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_heightValue.toInt()} cm',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A73E8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Custom height slider
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          // Scale markings
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(11, (index) {
                              final height = 140 + (index * 5);
                              return Container(
                                width: 2,
                                height: index % 2 == 0 ? 20 : 10,
                                color: Colors.grey[400],
                                margin: EdgeInsets.only(
                                  left: index == 0 ? 10 : 0,
                                  right: index == 10 ? 10 : 0,
                                  top: 10,
                                ),
                              );
                            }),
                          ),

                          // Slider
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 2,
                              activeTrackColor: const Color(0xFF1A73E8),
                              inactiveTrackColor: Colors.grey[300],
                              thumbColor: Colors.white,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 15,
                                elevation: 4,
                              ),
                              overlayColor:
                                  const Color(0xFF1A73E8).withOpacity(0.2),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 25),
                            ),
                            child: Slider(
                              value: _heightValue,
                              min: 140,
                              max: 190,
                              onChanged: (value) {
                                setState(() {
                                  _heightValue = value;
                                  _userData.height = value;
                                });
                              },
                            ),
                          ),

                          // Height indicator
                          Positioned(
                            left: ((_heightValue - 140) / 50) *
                                    (MediaQuery.of(context).size.width - 80) +
                                20,
                            bottom: 0,
                            child: Container(
                              width: 2,
                              height: 40,
                              color: const Color(0xFF1A73E8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Height labels
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('140 cm',
                              style: TextStyle(color: Colors.grey)),
                          const Text('165 cm',
                              style: TextStyle(color: Colors.grey)),
                          const Text('190 cm',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cân nặng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A73E8).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_weightValue.toInt()} kg',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A73E8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Custom weight slider
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          // Scale markings
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(11, (index) {
                              return Container(
                                width: 2,
                                height: index % 2 == 0 ? 20 : 10,
                                color: Colors.grey[400],
                                margin: EdgeInsets.only(
                                  left: index == 0 ? 10 : 0,
                                  right: index == 10 ? 10 : 0,
                                  top: 10,
                                ),
                              );
                            }),
                          ),

                          // Slider
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 2,
                              activeTrackColor: const Color(0xFF1A73E8),
                              inactiveTrackColor: Colors.grey[300],
                              thumbColor: Colors.white,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 15,
                                elevation: 4,
                              ),
                              overlayColor:
                                  const Color(0xFF1A73E8).withOpacity(0.2),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 25),
                            ),
                            child: Slider(
                              value: _weightValue,
                              min: 40,
                              max: 120,
                              onChanged: (value) {
                                setState(() {
                                  _weightValue = value;
                                  _userData.weight = value;
                                });
                              },
                            ),
                          ),

                          // Weight indicator
                          Positioned(
                            left: ((_weightValue - 40) / 80) *
                                    (MediaQuery.of(context).size.width - 80) +
                                20,
                            bottom: 0,
                            child: Container(
                              width: 2,
                              height: 40,
                              color: const Color(0xFF1A73E8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Weight labels
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('40 kg',
                              style: TextStyle(color: Colors.grey)),
                          const Text('80 kg',
                              style: TextStyle(color: Colors.grey)),
                          const Text('120 kg',
                              style: TextStyle(color: Colors.grey)),
                        ],
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

  Widget _buildGenderAndBirthdayPage() {
    return SlideTransition(
      position: _slideAnimation,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Giới tính & Ngày sinh',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Hãy cho chúng tôi biết thêm về bạn',
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
                    const SizedBox(height: 20),
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

              // Birthday selection
              Container(
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
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _showDatePicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
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
                    const SizedBox(height: 10),
                    Text(
                      'Tuổi: ${DateTime.now().year - _selectedDate.year}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
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
        padding: const EdgeInsets.all(15),
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
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
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
    return SlideTransition(
      position: _slideAnimation,
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
                    final isSelected =
                        _userData.medicalConditions.contains(condition);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (condition == 'None') {
                            if (!isSelected) {
                              _userData.medicalConditions.clear();
                              _userData.medicalConditions.add('None');
                            } else {
                              _userData.medicalConditions.remove('None');
                            }
                          } else {
                            if (!isSelected) {
                              _userData.medicalConditions.add(condition);
                              _userData.medicalConditions.remove('None');
                            } else {
                              _userData.medicalConditions.remove(condition);
                            }
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1A73E8).withOpacity(0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1A73E8)
                                : Colors.grey[300]!,
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
                                color: isSelected
                                    ? const Color(0xFF1A73E8)
                                    : Colors.white,
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
                              condition,
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected
                                    ? const Color(0xFF1A73E8)
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
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
    return SlideTransition(
      position: _slideAnimation,
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
                    final isSelected = _userData.allergies.contains(allergy);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (allergy == 'None') {
                            if (!isSelected) {
                              _userData.allergies.clear();
                              _userData.allergies.add('None');
                            } else {
                              _userData.allergies.remove('None');
                            }
                          } else {
                            if (!isSelected) {
                              _userData.allergies.add(allergy);
                              _userData.allergies.remove('None');
                            } else {
                              _userData.allergies.remove(allergy);
                            }
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1A73E8).withOpacity(0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1A73E8)
                                : Colors.grey[300]!,
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
                                color: isSelected
                                    ? const Color(0xFF1A73E8)
                                    : Colors.white,
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
                                color: isSelected
                                    ? const Color(0xFF1A73E8)
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
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
    return SlideTransition(
      position: _slideAnimation,
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
                    final isSelected =
                        _userData.dietType == dietType.toLowerCase();

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _userData.dietType = dietType.toLowerCase();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1A73E8).withOpacity(0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1A73E8)
                                : Colors.grey[300]!,
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
                                color: isSelected
                                    ? const Color(0xFF1A73E8)
                                    : Colors.white,
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
                                        Icons.circle,
                                        size: 12,
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
                                color: isSelected
                                    ? const Color(0xFF1A73E8)
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
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
    return SlideTransition(
      position: _slideAnimation,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cân nặng mục tiêu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A73E8).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_targetWeightValue.toInt()} kg',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A73E8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Custom target weight slider
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          // Scale markings
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(11, (index) {
                              return Container(
                                width: 2,
                                height: index % 2 == 0 ? 20 : 10,
                                color: Colors.grey[400],
                                margin: EdgeInsets.only(
                                  left: index == 0 ? 10 : 0,
                                  right: index == 10 ? 10 : 0,
                                  top: 10,
                                ),
                              );
                            }),
                          ),

                          // Slider
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 2,
                              activeTrackColor: const Color(0xFF1A73E8),
                              inactiveTrackColor: Colors.grey[300],
                              thumbColor: Colors.white,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 15,
                                elevation: 4,
                              ),
                              overlayColor:
                                  const Color(0xFF1A73E8).withOpacity(0.2),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 25),
                            ),
                            child: Slider(
                              value: _targetWeightValue,
                              min: 40,
                              max: 120,
                              onChanged: (value) {
                                setState(() {
                                  _targetWeightValue = value;
                                  _userData.targetWeight = value;
                                });
                              },
                            ),
                          ),

                          // Target weight indicator
                          Positioned(
                            left: ((_targetWeightValue - 40) / 80) *
                                    (MediaQuery.of(context).size.width - 80) +
                                20,
                            bottom: 0,
                            child: Container(
                              width: 2,
                              height: 40,
                              color: const Color(0xFF1A73E8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Weight labels
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('40 kg',
                              style: TextStyle(color: Colors.grey)),
                          const Text('80 kg',
                              style: TextStyle(color: Colors.grey)),
                          const Text('120 kg',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
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
                          'Cân nặng hiện tại của bạn: ${_userData.weight?.toInt()} kg',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // Weight difference
              if (_userData.weight != null)
                Container(
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
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mục tiêu của bạn',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A73E8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${_userData.weight?.toInt()} kg',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Hiện tại',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            width: 80,
                            height: 2,
                            color: Colors.grey[300],
                          ),
                          Column(
                            children: [
                              Text(
                                '${_targetWeightValue.toInt()} kg',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A73E8),
                                ),
                              ),
                              const Text(
                                'Mục tiêu',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          _userData.weight! > _targetWeightValue
                              ? 'Bạn cần giảm ${(_userData.weight! - _targetWeightValue).toInt()} kg'
                              : _userData.weight! < _targetWeightValue
                                  ? 'Bạn cần tăng ${(_targetWeightValue - _userData.weight!).toInt()} kg'
                                  : 'Bạn đã đạt được cân nặng mục tiêu!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _userData.weight! > _targetWeightValue
                                ? Colors.orange
                                : _userData.weight! < _targetWeightValue
                                    ? Colors.green
                                    : const Color(0xFF1A73E8),
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
    return SlideTransition(
      position: _slideAnimation,
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
                    final isSelected = _userData.activityLevel == value;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _userData.activityLevel = value;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1A73E8).withOpacity(0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1A73E8)
                                : Colors.grey[300]!,
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
                                color: isSelected
                                    ? const Color(0xFF1A73E8)
                                    : Colors.white,
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
                                        Icons.circle,
                                        size: 12,
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
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
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

              const SizedBox(height: 20),

              // Activity level description
              if (_userData.activityLevel != null)
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
                          _getActivityLevelDescription(
                              _userData.activityLevel!),
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

  String _getActivityLevelDescription(String level) {
    switch (level) {
      case 'sedentary':
        return 'Bạn hầu như không tập thể dục và có lối sống ít vận động.';
      case 'light':
        return 'Bạn tập thể dục nhẹ nhàng 1-3 lần mỗi tuần.';
      case 'moderate':
        return 'Bạn tập thể dục vừa phải 3-5 lần mỗi tuần.';
      case 'active':
        return 'Bạn tập thể dục đều đặn 6-7 lần mỗi tuần.';
      case 'very_active':
        return 'Bạn tập thể dục cường độ cao hàng ngày hoặc tập luyện thể thao chuyên nghiệp.';
      default:
        return '';
    }
  }
}
