import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<String> _getUsername() async {
    // Retrieve the username from local storage
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'User'; // Default to 'User' if not set
  }

  Future<void> _logout(BuildContext context) async {
    // Clear user session and navigate to login page
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved preferences
    Navigator.pushReplacementNamed(context, '/login'); // Redirect to login page
  }

  @override
  Widget build(BuildContext context) {
    // Mock data for quick stats (Replace with actual dynamic data if available)
    const double bmi = 23.5; // Mock BMI data
    const int workouts = 20; // Mock workouts count
    const int calories = 1500; // Mock calorie count
    const int waterIntake = 2; // Mock water intake in liters

    // Motivational quotes
    final List<String> quotes = [
      "The journey of a thousand miles begins with one step.",
      "Your health is your wealth.",
      "Sweat is just fat crying.",
      "Strive for progress, not perfection.",
    ];
    final String quote = quotes[DateTime.now().day % quotes.length]; // Rotate quotes daily

    return Scaffold(
      appBar: AppBar(
        title: const Text('WellnessPath'),
        centerTitle: true,
        backgroundColor: Colors.green, // Use consistent branding colors
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context), // Logout and redirect to login page
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<String>(
            future: _getUsername(), // Fetch username asynchronously
            builder: (context, snapshot) {
              String username = snapshot.data ?? 'User';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Welcome Banner with Username
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.lightGreenAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back, $username!',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Let’s achieve your wellness goals today.',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Horizontal Quick Stats Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard('BMI', bmi.toStringAsFixed(1), Icons.fitness_center),
                      _buildStatCard('Workouts', workouts.toString(), Icons.directions_run),
                      _buildStatCard('Calories', calories.toString(), Icons.local_fire_department),
                      _buildStatCard('Water', '$waterIntake L', Icons.local_drink),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Motivational Quote Section
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.lightGreenAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.format_quote, color: Colors.green, size: 30),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            quote,
                            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Navigation Buttons
                  Column(
                    children: [
                      _buildNavigationButton(
                        context,
                        'Log Meals',
                        Icons.fastfood,
                        Colors.orange,
                        '/meal_log', // Adjust route as necessary
                      ),
                      const SizedBox(height: 10),
                      _buildNavigationButton(
                        context,
                        'Log Workouts',
                        Icons.fitness_center,
                        Colors.blue,
                        '/workout_log', // Adjust route as necessary
                      ),
                      const SizedBox(height: 10),
                      _buildNavigationButton(
                        context,
                        'Log Water Intake',
                        Icons.local_drink,
                        Colors.cyan,
                        '/water_intake', // Adjust route as necessary
                      ),
                      const SizedBox(height: 10),
                      _buildNavigationButton(
                        context,
                        'View Progress',
                        Icons.show_chart,
                        Colors.green,
                        '/progress', // Adjust route as necessary
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper method to build stat cards
  Widget _buildStatCard(String label, String value, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 100, // Consistent card width
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.green, size: 30),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // Helper method to build navigation buttons
  Widget _buildNavigationButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    String route,
  ) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, route); // Navigate to the specified route
      },
      icon: Icon(icon, size: 24),
      label: Text(label, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Use consistent styling
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
