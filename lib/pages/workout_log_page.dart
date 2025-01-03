import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellnesspath/services/api_service.dart';

class WorkoutLogPage extends StatefulWidget {
  const WorkoutLogPage({super.key});

  @override
  _WorkoutLogPageState createState() => _WorkoutLogPageState();
}

class _WorkoutLogPageState extends State<WorkoutLogPage> {
  final TextEditingController _typeController = TextEditingController(); // Input for workout type
  final TextEditingController _durationController = TextEditingController(); // Input for workout duration
  final TextEditingController _caloriesController = TextEditingController(); // Input for calories burned
  DateTime? _selectedDate; // Workout date

  // Function to log a workout to the server
  Future<void> _logWorkout() async {
    final prefs = await SharedPreferences.getInstance(); // Access user data locally
    final userId = prefs.getInt('user_id'); // Retrieve logged-in user's ID

    // Ensure all fields are filled
    if (userId == null || _typeController.text.isEmpty || _durationController.text.isEmpty || _caloriesController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    try {
      // Send workout data to the server
      final response = await ApiService.post('?action=logWorkout', {
        'user_id': userId.toString(),
        'workout_type': _typeController.text,
        'duration': _durationController.text,
        'calories_burned': _caloriesController.text,
        'date': _selectedDate!.toIso8601String(), // Format the date as ISO8601
      });

      // Show success or error message
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout logged successfully!')));
        // Clear input fields
        _typeController.clear();
        _durationController.clear();
        _caloriesController.clear();
        setState(() {
          _selectedDate = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to log workout.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Workout'), // Page title
        backgroundColor: Colors.green, // Align with the theme color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center align items
            children: [
              // Welcome banner for the page
              Container(
                width: double.infinity, // Stretch across the screen
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.lightGreenAccent], // Gradient colors for styling
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10), // Rounded edges
                ),
                child: const Text(
                  'Log Your Workout', // Banner text
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center, // Center align text
                ),
              ),
              const SizedBox(height: 20),

              // Input field for workout type
              TextField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Workout Type (e.g., Running)'), // Label for user input
              ),
              const SizedBox(height: 10),

              // Input field for workout duration
              TextField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (minutes)'), // Label for user input
                keyboardType: TextInputType.number, // Use numeric keyboard
              ),
              const SizedBox(height: 10),

              // Input field for calories burned
              TextField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: 'Calories Burned'), // Label for user input
                keyboardType: TextInputType.number, // Use numeric keyboard
              ),
              const SizedBox(height: 10),

              // Date picker for workout date
              ElevatedButton(
                onPressed: () async {
                  // Show date picker dialog
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), // Default date is today
                    firstDate: DateTime(2000), // Allow selection from year 2000
                    lastDate: DateTime.now(), // Disable future dates
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate; // Save selected date
                    });
                  }
                },
                child: Text(
                  _selectedDate == null
                      ? 'Select Date' // Prompt user to select a date
                      : 'Selected Date: ${_selectedDate!.toLocal()}'.split(' ')[0], // Display selected date
                ),
              ),
              const SizedBox(height: 20),

              // Button to log workout
              ElevatedButton(
                onPressed: _logWorkout, // Call log workout function
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Match theme color
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Log Workout', // Button text
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
