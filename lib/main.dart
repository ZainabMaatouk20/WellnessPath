import 'package:flutter/material.dart';
import 'package:wellnesspath/pages/meal_log_page.dart';
import 'package:wellnesspath/pages/workout_log_page.dart';
import 'package:wellnesspath/pages/progress_page.dart';
import 'package:wellnesspath/pages/home_page.dart';
import 'package:wellnesspath/pages/login_page.dart';
import 'package:wellnesspath/pages/register_page.dart';
import 'package:wellnesspath/pages/water_intake_page.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; // For storing user session

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Retrieve stored user ID to check login status
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');
  runApp(MyApp(isLoggedIn: userId != null)); // Check if a user is logged in
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WellnessPath', // App title shown in task switchers
      theme: ThemeData(
        primarySwatch: Colors.green, // Theme customization for app
      ),
      // Define the initial route
      initialRoute: isLoggedIn ? '/home' : '/login',
      // Define the application routes
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) =>  RegisterPage(),
        '/home': (context) => const HomePage(),
        '/meal_log': (context) => const MealLogPage(),
        '/workout_log': (context) =>const WorkoutLogPage(),
        '/progress': (context) => const ProgressPage(),
        '/water_intake': (context) => const WaterIntakePage(), // Add Water Intake Page route
      },
    );
  }
}

