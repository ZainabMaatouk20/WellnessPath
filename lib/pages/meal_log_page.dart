import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:wellnesspath/services/api_service.dart';

class MealLogPage extends StatefulWidget {
  const MealLogPage({super.key});

  @override
  _MealLogPageState createState() => _MealLogPageState();
}

class _MealLogPageState extends State<MealLogPage> {
  final TextEditingController _foodController = TextEditingController(); // Input for food item
  final TextEditingController _calorieController = TextEditingController(); // Input for calorie count
  String? _selectedMealType; // Dropdown selection for meal type
  DateTime? _selectedDate; // Meal date

  // Function to log a meal to the server
  Future<void> _logMeal() async {
    final prefs = await SharedPreferences.getInstance(); // Access user data locally
    final userId = prefs.getInt('user_id'); // Retrieve logged-in user's ID

    // Ensure all fields are filled
    if (userId == null || _foodController.text.isEmpty || _calorieController.text.isEmpty || _selectedMealType == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    try {
      // Send meal data to the server
      final response = await ApiService.post('?action=logMeal', {
        'user_id': userId.toString(),
        'food_item': _foodController.text,
        'calories': _calorieController.text,
        'meal_type': _selectedMealType!,
        'date': _selectedDate!.toIso8601String(), // Format the date as ISO8601
      });

      final data = json.decode(response.body); // Parse the server's response

      // Show success or error message
      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Meal logged successfully!')));
        // Clear input fields
        _foodController.clear();
        _calorieController.clear();
        setState(() {
          _selectedMealType = null;
          _selectedDate = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['error'] ?? 'Failed to log meal.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Meal'),
        backgroundColor: Colors.green, // Align with the home page theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Align center
          children: [
            // Welcome banner for the log meal page
            Container(
              width: double.infinity, // Stretch across the screen
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.lightGreenAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Log Your Meal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ),
            const SizedBox(height: 20),

            // Input field for food item
            TextField(
              controller: _foodController,
              decoration: const InputDecoration(labelText: 'Food Item'),
            ),
            const SizedBox(height: 10),

            // Input field for calorie count
            TextField(
              controller: _calorieController,
              decoration: const InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number, // Numeric keyboard
            ),
            const SizedBox(height: 10),

            // Dropdown menu for meal type
            DropdownButton<String>(
              value: _selectedMealType,
              hint: const Text('Select Meal Type'),
              items: ['Breakfast', 'Lunch', 'Dinner', 'Snack']
                  .map((type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMealType = value; // Update selected meal type
                });
              },
            ),
            const SizedBox(height: 10),

            // Button for selecting meal date
            ElevatedButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate; // Update selected date
                  });
                }
              },
              child: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : 'Selected Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
              ),
            ),
            const SizedBox(height: 20),

            // Button to log the meal
            ElevatedButton(
              onPressed: _logMeal, // Call the log meal function
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Match the theme
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Log Meal',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
