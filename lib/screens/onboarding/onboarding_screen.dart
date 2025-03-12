import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'username_page.dart';
import 'height_weight_page.dart';
import 'gender_birthday_page.dart';
import 'medical_conditions_page.dart';
import 'allergies_page.dart';
import 'diet_type_page.dart';
import 'target_weight_page.dart';
import 'activity_level_page.dart';
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

  // Animation controllers
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

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
    if (_currentPage < 7) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _slideController.forward(from: 0.0);
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _slideController.forward(from: 0.0);
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
                    child: const Text('Xác nh���n'),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _userData.dateOfBirth ??
                      DateTime.now().subtract(const Duration(days: 365 * 25)),
                  maximumDate: DateTime.now(),
                  minimumDate: DateTime(1900),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _userData.dateOfBirth = newDate;
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
                            'Bước ${_currentPage + 1}/8',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (_currentPage + 1) / 8,
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
                    children: [
                      KeepAlivePage(
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: UsernamePage(
                            userData: _userData,
                            onUsernameChanged: (value) =>
                                setState(() => _userData.username = value),
                          ),
                        ),
                      ),
                      KeepAlivePage(
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: HeightWeightPage(
                            userData: _userData,
                            onHeightChanged: (value) =>
                                setState(() => _userData.height = value),
                            onWeightChanged: (value) =>
                                setState(() => _userData.weight = value),
                          ),
                        ),
                      ),
                      KeepAlivePage(
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: GenderBirthdayPage(
                            userData: _userData,
                            onGenderChanged: (value) =>
                                setState(() => _userData.gender = value),
                            onBirthdayChanged: (value) =>
                                setState(() => _userData.dateOfBirth = value),
                            showDatePicker: _showDatePicker,
                          ),
                        ),
                      ),
                      KeepAlivePage(
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: MedicalConditionsPage(
                            userData: _userData,
                            onMedicalConditionToggled: (condition) {
                              setState(() {
                                if (_userData.medicalConditions
                                    .contains(condition)) {
                                  _userData.medicalConditions.remove(condition);
                                } else {
                                  _userData.medicalConditions.add(condition);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      KeepAlivePage(
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: AllergiesPage(
                            userData: _userData,
                            onAllergyToggled: (allergy) {
                              setState(() {
                                if (_userData.allergies.contains(allergy)) {
                                  _userData.allergies.remove(allergy);
                                } else {
                                  _userData.allergies.add(allergy);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      KeepAlivePage(
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: DietTypePage(
                            userData: _userData,
                            onDietTypeChanged: (value) =>
                                setState(() => _userData.dietType = value),
                          ),
                        ),
                      ),
                      KeepAlivePage(
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: TargetWeightPage(
                            userData: _userData,
                            onTargetWeightChanged: (value) =>
                                setState(() => _userData.targetWeight = value),
                          ),
                        ),
                      ),
                      KeepAlivePage(
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: ActivityLevelPage(
                            userData: _userData,
                            onActivityLevelChanged: (value) =>
                                setState(() => _userData.activityLevel = value),
                          ),
                        ),
                      ),
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
                        icon: _currentPage < 7
                            ? const Icon(Icons.arrow_forward)
                            : const Icon(Icons.check),
                        label: Text(
                          _currentPage < 7 ? 'Tiếp tục' : 'Hoàn thành',
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
}

class KeepAlivePage extends StatefulWidget {
  final Widget child;

  const KeepAlivePage({Key? key, required this.child}) : super(key: key);

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
