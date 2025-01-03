import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:wellnesspath/services/api_service.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  Map<String, dynamic>? dailyProgress;
  Map<String, dynamic>? detailedProgress;
  bool isLoading = true;
  final TextEditingController _weightController = TextEditingController();
  bool hasLoggedWeight = false;

  Future<void> fetchProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to view progress.')),
      );
      return;
    }

    try {
      final response = await ApiService.get('?action=getProgress&user_id=$userId');
      final data = json.decode(response.body);

      if (data['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['error'])));
        return;
      }

      setState(() {
        dailyProgress = data['daily'];
        detailedProgress = data['detailed'];
        hasLoggedWeight = detailedProgress?['weight'] != null;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> logWeight() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null || _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in and enter weight.')),
      );
      return;
    }

    try {
      final response = await ApiService.post('?action=logProgress', {
        'user_id': userId.toString(),
        'weight': _weightController.text,
        'date': DateTime.now().toIso8601String(),
      });

      final data = json.decode(response.body);

      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Weight logged successfully!')));
        fetchProgress();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['error'] ?? 'Failed to log weight.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProgress();
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.9; // 90% of screen width
    return Scaffold(
      appBar: AppBar(title: const Text('Progress'), backgroundColor: Colors.green),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Card 1: Daily Progress
                    if (dailyProgress != null)
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                        child: Container(
                          width: cardWidth, // Dynamic width for the card
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.blueAccent, Colors.lightBlue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Daily Progress',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Calories Consumed: ${dailyProgress?['calories_consumed']} kcal',
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                'Calories Burned: ${dailyProgress?['calories_burned']} kcal',
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                'Workouts: ${dailyProgress?['workouts_count']}',
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                'Water Intake: ${dailyProgress?['water_intake']} ml',
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Card 2: Detailed Progress or Weight Logging
                    if (!hasLoggedWeight)
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                        child: Container(
                          width: cardWidth, // Dynamic width for the card
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.greenAccent, Colors.lightGreen],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Log Your Weight',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _weightController,
                                decoration: const InputDecoration(
                                  labelText: 'Weight (kg)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: logWeight,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Log Weight', style: TextStyle(fontSize: 18)),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                        child: Container(
                          width: cardWidth, // Dynamic width for the card
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.deepOrangeAccent, Colors.orange],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Detailed Progress',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Weight: ${detailedProgress?['weight']} kg',
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                'Height: ${detailedProgress?['height']} cm',
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                'BMI: ${double.tryParse(detailedProgress?['bmi']?.toString() ?? '0')?.toStringAsFixed(1) ?? 'N/A'}',
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                'Body Fat: ${double.tryParse(detailedProgress?['body_fat']?.toString() ?? '0')?.toStringAsFixed(1) ?? 'N/A'}%',
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                'Muscle Mass: ${double.tryParse(detailedProgress?['muscle_mass']?.toString() ?? '0')?.toStringAsFixed(1) ?? 'N/A'} kg',
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                'Daily Calories Needed: ${detailedProgress?['daily_calories_needed']} kcal',
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ],
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
