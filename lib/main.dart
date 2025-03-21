import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'services/user_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final isOnboardingComplete = await UserService.isOnboardingComplete();

  runApp(MyApp(
    cameras: cameras,
    isOnboardingComplete: isOnboardingComplete,
  ));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  final bool isOnboardingComplete;

  const MyApp({
    Key? key,
    required this.cameras,
    required this.isOnboardingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriLens',
      theme: ThemeData(
        primaryColor: const Color(0xFF1A73E8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
          primary: const Color(0xFF1A73E8),
          secondary: const Color(0xFF66B2FF),
          background: Colors.white,
        ),
        fontFamily: 'Roboto',
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Roboto',
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A73E8),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A73E8),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1A73E8),
          foregroundColor: Colors.white,
        ),
      ),
      home: SplashScreen(cameras: cameras),
      debugShowCheckedModeBanner: false,
    );
  }
}
